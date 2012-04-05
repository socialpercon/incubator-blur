#
# Autogenerated by Thrift Compiler (0.7.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#


module Blur
    module ScoreType
      SUPER = 0
      AGGREGATE = 1
      BEST = 2
      CONSTANT = 3
      VALUE_MAP = {0 => "SUPER", 1 => "AGGREGATE", 2 => "BEST", 3 => "CONSTANT"}
      VALID_VALUES = Set.new([SUPER, AGGREGATE, BEST, CONSTANT]).freeze
    end

    module QueryState
      RUNNING = 0
      INTERRUPTED = 1
      COMPLETE = 2
      VALUE_MAP = {0 => "RUNNING", 1 => "INTERRUPTED", 2 => "COMPLETE"}
      VALID_VALUES = Set.new([RUNNING, INTERRUPTED, COMPLETE]).freeze
    end

    module RowMutationType
      DELETE_ROW = 0
      REPLACE_ROW = 1
      UPDATE_ROW = 2
      VALUE_MAP = {0 => "DELETE_ROW", 1 => "REPLACE_ROW", 2 => "UPDATE_ROW"}
      VALID_VALUES = Set.new([DELETE_ROW, REPLACE_ROW, UPDATE_ROW]).freeze
    end

    module RecordMutationType
      DELETE_ENTIRE_RECORD = 0
      REPLACE_ENTIRE_RECORD = 1
      REPLACE_COLUMNS = 2
      APPEND_COLUMN_VALUES = 3
      VALUE_MAP = {0 => "DELETE_ENTIRE_RECORD", 1 => "REPLACE_ENTIRE_RECORD", 2 => "REPLACE_COLUMNS", 3 => "APPEND_COLUMN_VALUES"}
      VALID_VALUES = Set.new([DELETE_ENTIRE_RECORD, REPLACE_ENTIRE_RECORD, REPLACE_COLUMNS, APPEND_COLUMN_VALUES]).freeze
    end

    # BlurException that carries a message plus the original stack
    # trace (if any).
    class BlurException < ::Thrift::Exception
      include ::Thrift::Struct, ::Thrift::Struct_Union
      MESSAGE = 1
      STACKTRACESTR = 2

      FIELDS = {
        # The message in the exception.
        MESSAGE => {:type => ::Thrift::Types::STRING, :name => 'message'},
        # The original stack trace (if any).
        STACKTRACESTR => {:type => ::Thrift::Types::STRING, :name => 'stackTraceStr'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # Column is the lowest storage element in Blur, it stores a single name and value pair.
    class Column
      include ::Thrift::Struct, ::Thrift::Struct_Union
      NAME = 1
      VALUE = 2

      FIELDS = {
        # The name of the column.
        NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
        # The value to be indexed and stored.
        VALUE => {:type => ::Thrift::Types::STRING, :name => 'value'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # Records contain a list of columns, multiple columns with the same name are allowed.
    class Record
      include ::Thrift::Struct, ::Thrift::Struct_Union
      RECORDID = 1
      FAMILY = 2
      COLUMNS = 3

      FIELDS = {
        # Record id uniquely identifies a record within a single row.
        RECORDID => {:type => ::Thrift::Types::STRING, :name => 'recordId'},
        # The family in which this record resides.
        FAMILY => {:type => ::Thrift::Types::STRING, :name => 'family'},
        # A list of columns, multiple columns with the same name are allowed.
        COLUMNS => {:type => ::Thrift::Types::LIST, :name => 'columns', :element => {:type => ::Thrift::Types::STRUCT, :class => Blur::Column}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # Rows contain a list of records.
    class Row
      include ::Thrift::Struct, ::Thrift::Struct_Union
      ID = 1
      RECORDS = 2
      RECORDCOUNT = 3

      FIELDS = {
        # The row id.
        ID => {:type => ::Thrift::Types::STRING, :name => 'id'},
        # The list records within the row.  If paging is used this list will only
        # reflect the paged records from the selector.
        RECORDS => {:type => ::Thrift::Types::LIST, :name => 'records', :element => {:type => ::Thrift::Types::STRUCT, :class => Blur::Record}},
        # The total record count for the row.  If paging is used in a selector to page
        # through records of a row, this count will reflect the entire row.
        RECORDCOUNT => {:type => ::Thrift::Types::I32, :name => 'recordCount'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # Select carries the request for information to be retrieved from the stored columns.
    class Selector
      include ::Thrift::Struct, ::Thrift::Struct_Union
      RECORDONLY = 1
      LOCATIONID = 2
      ROWID = 3
      RECORDID = 4
      COLUMNFAMILIESTOFETCH = 5
      COLUMNSTOFETCH = 6
      ALLOWSTALEDATA = 7

      FIELDS = {
        # Fetch the Record only, not the entire Row.
        RECORDONLY => {:type => ::Thrift::Types::BOOL, :name => 'recordOnly'},
        # The location id of the Record or Row to be fetched.
        LOCATIONID => {:type => ::Thrift::Types::STRING, :name => 'locationId'},
        # The row id of the Row to be fetched, not to be used with location id.
        ROWID => {:type => ::Thrift::Types::STRING, :name => 'rowId'},
        # The record id of the Record to be fetched, not to be used with location id.  However the row id needs to be provided to locate the correct Row with the requested Record.
        RECORDID => {:type => ::Thrift::Types::STRING, :name => 'recordId'},
        # The column families to fetch.  If null, fetch all.  If empty, fetch none.
        COLUMNFAMILIESTOFETCH => {:type => ::Thrift::Types::SET, :name => 'columnFamiliesToFetch', :element => {:type => ::Thrift::Types::STRING}},
        # The columns in the families to fetch.  If null, fetch all.  If empty, fetch none.
        COLUMNSTOFETCH => {:type => ::Thrift::Types::MAP, :name => 'columnsToFetch', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::SET, :element => {:type => ::Thrift::Types::STRING}}},
        # @deprecated This value is no longer used.  This allows the fetch to see the most current data that has been added to the table.
        ALLOWSTALEDATA => {:type => ::Thrift::Types::BOOL, :name => 'allowStaleData'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # FetchRowResult contains row result from a fetch.
    class FetchRowResult
      include ::Thrift::Struct, ::Thrift::Struct_Union
      ROW = 1

      FIELDS = {
        # The row fetched.
        ROW => {:type => ::Thrift::Types::STRUCT, :name => 'row', :class => Blur::Row}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # FetchRecordResult contains rowid of the record and the record result from a fetch.
    class FetchRecordResult
      include ::Thrift::Struct, ::Thrift::Struct_Union
      ROWID = 1
      RECORD = 2

      FIELDS = {
        # The row id of the record being fetched.
        ROWID => {:type => ::Thrift::Types::STRING, :name => 'rowid'},
        # The record fetched.
        RECORD => {:type => ::Thrift::Types::STRUCT, :name => 'record', :class => Blur::Record}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # FetchResult contains the row or record fetch result based if the Selector was going to fetch the entire row or a single record.
    class FetchResult
      include ::Thrift::Struct, ::Thrift::Struct_Union
      EXISTS = 1
      DELETED = 2
      TABLE = 3
      ROWRESULT = 4
      RECORDRESULT = 5

      FIELDS = {
        # True if the result exists, false if it doesn't.
        EXISTS => {:type => ::Thrift::Types::BOOL, :name => 'exists'},
        # If the row was marked as deleted.
        DELETED => {:type => ::Thrift::Types::BOOL, :name => 'deleted'},
        # The table the fetch result came from.
        TABLE => {:type => ::Thrift::Types::STRING, :name => 'table'},
        # The row result if a row was selected form the Selector.
        ROWRESULT => {:type => ::Thrift::Types::STRUCT, :name => 'rowResult', :class => Blur::FetchRowResult},
        # The record result if a record was selected form the Selector.
        RECORDRESULT => {:type => ::Thrift::Types::STRUCT, :name => 'recordResult', :class => Blur::FetchRecordResult}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # The SimpleQuery object holds the query string (normal Lucene syntax), filters and type of scoring (used when super query is on).
    class SimpleQuery
      include ::Thrift::Struct, ::Thrift::Struct_Union
      QUERYSTR = 1
      SUPERQUERYON = 2
      TYPE = 3
      POSTSUPERFILTER = 4
      PRESUPERFILTER = 5

      FIELDS = {
        # A Lucene syntax based query.
        QUERYSTR => {:type => ::Thrift::Types::STRING, :name => 'queryStr'},
        # If the super query is on, meaning the query will be perform against all the records (joining records in some cases) and the result will be Rows (groupings of Record).
        SUPERQUERYON => {:type => ::Thrift::Types::BOOL, :name => 'superQueryOn', :default => true},
        # The scoring type, see the document on ScoreType for explanation of each score type.
        TYPE => {:type => ::Thrift::Types::I32, :name => 'type', :default =>         0, :enum_class => Blur::ScoreType},
        # The post super filter (normal Lucene syntax), is a filter performed after the join to filter out entire rows from the results.
        POSTSUPERFILTER => {:type => ::Thrift::Types::STRING, :name => 'postSuperFilter'},
        # The pre super filter (normal Lucene syntax), is a filter performed before the join to filter out records from the results.
        PRESUPERFILTER => {:type => ::Thrift::Types::STRING, :name => 'preSuperFilter'}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @type.nil? || Blur::ScoreType::VALID_VALUES.include?(@type)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field type!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    # The expert query allows for submission of a serialized query and filter object to be executed against all the queries.
    class ExpertQuery
      include ::Thrift::Struct, ::Thrift::Struct_Union
      QUERY = 1
      FILTER = 2

      FIELDS = {
        # The serialized query.
        QUERY => {:type => ::Thrift::Types::STRING, :name => 'query', :binary => true},
        # The serialized filter.
        FILTER => {:type => ::Thrift::Types::STRING, :name => 'filter', :binary => true}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # Blur facet.
    class Facet
      include ::Thrift::Struct, ::Thrift::Struct_Union
      QUERYSTR = 1
      MINIMUMNUMBEROFBLURRESULTS = 2

      FIELDS = {
        QUERYSTR => {:type => ::Thrift::Types::STRING, :name => 'queryStr'},
        MINIMUMNUMBEROFBLURRESULTS => {:type => ::Thrift::Types::I64, :name => 'minimumNumberOfBlurResults', :default => 9223372036854775807}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class BlurQuery
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SIMPLEQUERY = 1
      EXPERTQUERY = 2
      FACETS = 3
      SELECTOR = 4
      ALLOWSTALEDATA = 5
      USECACHEIFPRESENT = 6
      START = 7
      FETCH = 8
      MINIMUMNUMBEROFRESULTS = 9
      MAXQUERYTIME = 10
      UUID = 11
      USERCONTEXT = 12
      CACHERESULT = 13
      STARTTIME = 14
      MODIFYFILECACHES = 15

      FIELDS = {
        # 
        SIMPLEQUERY => {:type => ::Thrift::Types::STRUCT, :name => 'simpleQuery', :class => Blur::SimpleQuery},
        # 
        EXPERTQUERY => {:type => ::Thrift::Types::STRUCT, :name => 'expertQuery', :class => Blur::ExpertQuery},
        # 
        FACETS => {:type => ::Thrift::Types::LIST, :name => 'facets', :element => {:type => ::Thrift::Types::STRUCT, :class => Blur::Facet}},
        # Selector is used to fetch data in the search results, if null only location ids will be fetched.
        SELECTOR => {:type => ::Thrift::Types::STRUCT, :name => 'selector', :class => Blur::Selector},
        # @deprecated This value is no longer used.  This allows the query to see the most current data that has been added to the table.
        ALLOWSTALEDATA => {:type => ::Thrift::Types::BOOL, :name => 'allowStaleData', :default => false},
        # 
        USECACHEIFPRESENT => {:type => ::Thrift::Types::BOOL, :name => 'useCacheIfPresent', :default => true},
        # 
        START => {:type => ::Thrift::Types::I64, :name => 'start', :default => 0},
        # 
        FETCH => {:type => ::Thrift::Types::I32, :name => 'fetch', :default => 10},
        # 
        MINIMUMNUMBEROFRESULTS => {:type => ::Thrift::Types::I64, :name => 'minimumNumberOfResults', :default => 9223372036854775807},
        # 
        MAXQUERYTIME => {:type => ::Thrift::Types::I64, :name => 'maxQueryTime', :default => 9223372036854775807},
        # 
        UUID => {:type => ::Thrift::Types::I64, :name => 'uuid'},
        # 
        USERCONTEXT => {:type => ::Thrift::Types::STRING, :name => 'userContext'},
        # 
        CACHERESULT => {:type => ::Thrift::Types::BOOL, :name => 'cacheResult', :default => true},
        # 
        STARTTIME => {:type => ::Thrift::Types::I64, :name => 'startTime', :default => 0},
        # 
        MODIFYFILECACHES => {:type => ::Thrift::Types::BOOL, :name => 'modifyFileCaches', :default => true}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class BlurResult
      include ::Thrift::Struct, ::Thrift::Struct_Union
      LOCATIONID = 1
      SCORE = 2
      FETCHRESULT = 3

      FIELDS = {
        # 
        LOCATIONID => {:type => ::Thrift::Types::STRING, :name => 'locationId'},
        # 
        SCORE => {:type => ::Thrift::Types::DOUBLE, :name => 'score'},
        # 
        FETCHRESULT => {:type => ::Thrift::Types::STRUCT, :name => 'fetchResult', :class => Blur::FetchResult}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class BlurResults
      include ::Thrift::Struct, ::Thrift::Struct_Union
      TOTALRESULTS = 1
      SHARDINFO = 2
      RESULTS = 3
      FACETCOUNTS = 4
      EXCEPTIONS = 5
      QUERY = 6

      FIELDS = {
        # 
        TOTALRESULTS => {:type => ::Thrift::Types::I64, :name => 'totalResults', :default => 0},
        # 
        SHARDINFO => {:type => ::Thrift::Types::MAP, :name => 'shardInfo', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::I64}},
        # 
        RESULTS => {:type => ::Thrift::Types::LIST, :name => 'results', :element => {:type => ::Thrift::Types::STRUCT, :class => Blur::BlurResult}},
        # 
        FACETCOUNTS => {:type => ::Thrift::Types::LIST, :name => 'facetCounts', :element => {:type => ::Thrift::Types::I64}},
        # 
        EXCEPTIONS => {:type => ::Thrift::Types::LIST, :name => 'exceptions', :element => {:type => ::Thrift::Types::STRUCT, :class => Blur::BlurException}},
        # 
        QUERY => {:type => ::Thrift::Types::STRUCT, :name => 'query', :class => Blur::BlurQuery}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class RecordMutation
      include ::Thrift::Struct, ::Thrift::Struct_Union
      RECORDMUTATIONTYPE = 1
      RECORD = 2

      FIELDS = {
        # 
        RECORDMUTATIONTYPE => {:type => ::Thrift::Types::I32, :name => 'recordMutationType', :enum_class => Blur::RecordMutationType},
        # 
        RECORD => {:type => ::Thrift::Types::STRUCT, :name => 'record', :class => Blur::Record}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @recordMutationType.nil? || Blur::RecordMutationType::VALID_VALUES.include?(@recordMutationType)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field recordMutationType!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class RowMutation
      include ::Thrift::Struct, ::Thrift::Struct_Union
      TABLE = 1
      ROWID = 2
      WAL = 3
      ROWMUTATIONTYPE = 4
      RECORDMUTATIONS = 5
      WAITTOBEVISIBLE = 6

      FIELDS = {
        # The that that the row mutation is to act upon.
        TABLE => {:type => ::Thrift::Types::STRING, :name => 'table'},
        # The row id that the row mutation is to act upon.
        ROWID => {:type => ::Thrift::Types::STRING, :name => 'rowId'},
        # Write ahead log, by default all updates are written to a write ahead log before the update is applied.  That way if a failure occurs before the index is committed the WAL can be replayed to recover any data that could have been lost.
        WAL => {:type => ::Thrift::Types::BOOL, :name => 'wal', :default => true},
        ROWMUTATIONTYPE => {:type => ::Thrift::Types::I32, :name => 'rowMutationType', :enum_class => Blur::RowMutationType},
        RECORDMUTATIONS => {:type => ::Thrift::Types::LIST, :name => 'recordMutations', :element => {:type => ::Thrift::Types::STRUCT, :class => Blur::RecordMutation}},
        # On mutate waits for the mutation to be visible to queries and fetch requests.
        WAITTOBEVISIBLE => {:type => ::Thrift::Types::BOOL, :name => 'waitToBeVisible', :default => false}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @rowMutationType.nil? || Blur::RowMutationType::VALID_VALUES.include?(@rowMutationType)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field rowMutationType!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class CpuTime
      include ::Thrift::Struct, ::Thrift::Struct_Union
      CPUTIME = 1
      REALTIME = 2

      FIELDS = {
        # 
        CPUTIME => {:type => ::Thrift::Types::I64, :name => 'cpuTime'},
        # 
        REALTIME => {:type => ::Thrift::Types::I64, :name => 'realTime'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class BlurQueryStatus
      include ::Thrift::Struct, ::Thrift::Struct_Union
      QUERY = 1
      CPUTIMES = 2
      COMPLETESHARDS = 3
      TOTALSHARDS = 4
      STATE = 5
      UUID = 6

      FIELDS = {
        # 
        QUERY => {:type => ::Thrift::Types::STRUCT, :name => 'query', :class => Blur::BlurQuery},
        # 
        CPUTIMES => {:type => ::Thrift::Types::MAP, :name => 'cpuTimes', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => Blur::CpuTime}},
        # 
        COMPLETESHARDS => {:type => ::Thrift::Types::I32, :name => 'completeShards'},
        # 
        TOTALSHARDS => {:type => ::Thrift::Types::I32, :name => 'totalShards'},
        # 
        STATE => {:type => ::Thrift::Types::I32, :name => 'state', :enum_class => Blur::QueryState},
        # 
        UUID => {:type => ::Thrift::Types::I64, :name => 'uuid'}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @state.nil? || Blur::QueryState::VALID_VALUES.include?(@state)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field state!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class TableStats
      include ::Thrift::Struct, ::Thrift::Struct_Union
      TABLENAME = 1
      BYTES = 2
      RECORDCOUNT = 3
      ROWCOUNT = 4
      QUERIES = 5

      FIELDS = {
        # 
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        # 
        BYTES => {:type => ::Thrift::Types::I64, :name => 'bytes'},
        # 
        RECORDCOUNT => {:type => ::Thrift::Types::I64, :name => 'recordCount'},
        # 
        ROWCOUNT => {:type => ::Thrift::Types::I64, :name => 'rowCount'},
        # 
        QUERIES => {:type => ::Thrift::Types::I64, :name => 'queries'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class Schema
      include ::Thrift::Struct, ::Thrift::Struct_Union
      TABLE = 1
      COLUMNFAMILIES = 2

      FIELDS = {
        # 
        TABLE => {:type => ::Thrift::Types::STRING, :name => 'table'},
        # 
        COLUMNFAMILIES => {:type => ::Thrift::Types::MAP, :name => 'columnFamilies', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::SET, :element => {:type => ::Thrift::Types::STRING}}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class AlternateColumnDefinition
      include ::Thrift::Struct, ::Thrift::Struct_Union
      ANALYZERCLASSNAME = 1

      FIELDS = {
        # 
        ANALYZERCLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'analyzerClassName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class ColumnDefinition
      include ::Thrift::Struct, ::Thrift::Struct_Union
      ANALYZERCLASSNAME = 1
      FULLTEXTINDEX = 2
      ALTERNATECOLUMNDEFINITIONS = 3

      FIELDS = {
        ANALYZERCLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'analyzerClassName', :default => %q"org.apache.lucene.analysis.standard.StandardAnalyzer"},
        FULLTEXTINDEX => {:type => ::Thrift::Types::BOOL, :name => 'fullTextIndex'},
        ALTERNATECOLUMNDEFINITIONS => {:type => ::Thrift::Types::MAP, :name => 'alternateColumnDefinitions', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => Blur::AlternateColumnDefinition}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class ColumnFamilyDefinition
      include ::Thrift::Struct, ::Thrift::Struct_Union
      DEFAULTDEFINITION = 1
      COLUMNDEFINITIONS = 2

      FIELDS = {
        # 
        DEFAULTDEFINITION => {:type => ::Thrift::Types::STRUCT, :name => 'defaultDefinition', :class => Blur::ColumnDefinition},
        # 
        COLUMNDEFINITIONS => {:type => ::Thrift::Types::MAP, :name => 'columnDefinitions', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => Blur::ColumnDefinition}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class AnalyzerDefinition
      include ::Thrift::Struct, ::Thrift::Struct_Union
      DEFAULTDEFINITION = 1
      FULLTEXTANALYZERCLASSNAME = 2
      COLUMNFAMILYDEFINITIONS = 3

      FIELDS = {
        # 
        DEFAULTDEFINITION => {:type => ::Thrift::Types::STRUCT, :name => 'defaultDefinition', :class => Blur::ColumnDefinition},
        # 
        FULLTEXTANALYZERCLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'fullTextAnalyzerClassName', :default => %q"org.apache.lucene.analysis.standard.StandardAnalyzer"},
        # 
        COLUMNFAMILYDEFINITIONS => {:type => ::Thrift::Types::MAP, :name => 'columnFamilyDefinitions', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => Blur::ColumnFamilyDefinition}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class ColumnPreCache
      include ::Thrift::Struct, ::Thrift::Struct_Union
      PRECACHECOLS = 1

      FIELDS = {
        # This map sets what column families and columns to prefetch into block cache on shard open.
        PRECACHECOLS => {:type => ::Thrift::Types::LIST, :name => 'preCacheCols', :element => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    # 
    class TableDescriptor
      include ::Thrift::Struct, ::Thrift::Struct_Union
      ISENABLED = 1
      ANALYZERDEFINITION = 2
      SHARDCOUNT = 3
      TABLEURI = 4
      COMPRESSIONCLASS = 5
      COMPRESSIONBLOCKSIZE = 6
      CLUSTER = 7
      NAME = 8
      SIMILARITYCLASS = 9
      BLOCKCACHING = 10
      BLOCKCACHINGFILETYPES = 11
      READONLY = 12
      COLUMNPRECACHE = 13

      FIELDS = {
        # 
        ISENABLED => {:type => ::Thrift::Types::BOOL, :name => 'isEnabled', :default => true},
        # 
        ANALYZERDEFINITION => {:type => ::Thrift::Types::STRUCT, :name => 'analyzerDefinition', :class => Blur::AnalyzerDefinition},
        # 
        SHARDCOUNT => {:type => ::Thrift::Types::I32, :name => 'shardCount', :default => 1},
        # 
        TABLEURI => {:type => ::Thrift::Types::STRING, :name => 'tableUri'},
        # 
        COMPRESSIONCLASS => {:type => ::Thrift::Types::STRING, :name => 'compressionClass', :default => %q"org.apache.hadoop.io.compress.DefaultCodec"},
        # 
        COMPRESSIONBLOCKSIZE => {:type => ::Thrift::Types::I32, :name => 'compressionBlockSize', :default => 32768},
        # 
        CLUSTER => {:type => ::Thrift::Types::STRING, :name => 'cluster'},
        # 
        NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
        # 
        SIMILARITYCLASS => {:type => ::Thrift::Types::STRING, :name => 'similarityClass'},
        # 
        BLOCKCACHING => {:type => ::Thrift::Types::BOOL, :name => 'blockCaching', :default => true},
        # 
        BLOCKCACHINGFILETYPES => {:type => ::Thrift::Types::SET, :name => 'blockCachingFileTypes', :element => {:type => ::Thrift::Types::STRING}},
        # 
        READONLY => {:type => ::Thrift::Types::BOOL, :name => 'readOnly', :default => false},
        # Sets what column families and columns to prefetch into block cache on shard open.
        COLUMNPRECACHE => {:type => ::Thrift::Types::STRUCT, :name => 'columnPreCache', :class => Blur::ColumnPreCache}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

  end
