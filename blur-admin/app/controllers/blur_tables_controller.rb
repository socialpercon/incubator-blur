class BlurTablesController < ApplicationController

  before_filter :current_zookeeper
  before_filter :zookeepers, :only => :index

  def index
    @clusters = @current_zookeeper.clusters.order('name')
    @clusters.each{|cluster| cluster.can_update = can?(:update, :blur_tables)}
    respond_to do |format|
      format.html
      format.json { render :json => @clusters, :methods => [:blur_tables] }
    end
  end

  def enable
    table_update_action do |table|
      table.status = STATUS[:enabling]
      table.enable @current_zookeeper.blur_urls
      Audit.log_event(current_user, "Table, #{table.table_name}, was enabled", "blur_table", "update", @current_zookeeper.name)
    end
  end

  def disable
    table_update_action do |table|
      table.status = STATUS[:disabling]
      table.disable @current_zookeeper.blur_urls
      Audit.log_event(current_user, "Table, #{table.table_name}, was disabled", "blur_table", "update", @current_zookeeper.name)
    end
  end

  def destroy
    table_update_action do |table|
      table.status = STATUS[:deleting]
      destroy_index = params[:delete_index] == 'true'
      table.blur_destroy destroy_index, @current_zookeeper.blur_urls
      message = "and underlying index" if destroy_index
      Audit.log_event(current_user, "Table, #{table.table_name}, #{message} was deleted", "blur_table", "update", @current_zookeeper.name)
      BlurTable.destroy table
    end
  end

  def terms
    table = BlurTable.find params[:id]
    terms = table.terms @current_zookeeper.blur_urls, params[:family], params[:column], params[:startwith], params[:size].to_i
    render :json => terms
  end

  def comment
    table = BlurTable.find params[:id]
    table.comments = params[:input]
    table.save
    render :nothing => true
  end

  private
    STATUS = {:enabling => 5, :active => 4, :disabling => 3, :disabled => 2, :deleting => 1, :deleted => 0}
    STATUS_SELECTOR = {:active => [4, 3], :disabled => [2, 5, 1], :deleted => [0]}

    def table_update_action
      updated_tables = params[:tables].map{|table| BlurTable.find(table)}
      updated_tables.each do |table|
        yield table
        table.save
      end
      render :nothing => true
    end
end
