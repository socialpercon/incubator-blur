/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.blur.manager.command.cmds;

import java.io.IOException;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.blur.manager.command.ClusterCommand;
import org.apache.blur.manager.command.ClusterContext;
import org.apache.blur.manager.command.IndexContext;
import org.apache.blur.manager.command.IndexReadCommand;
import org.apache.blur.manager.command.Shard;

@SuppressWarnings("serial")
public class DocumentCountNoCombine extends BaseCommand implements IndexReadCommand<Integer>, ClusterCommand<Long> {

  private static final String DOC_COUNT_NO_COMBINE = "docCountNoCombine";

  @Override
  public String getName() {
    return DOC_COUNT_NO_COMBINE;
  }

  @Override
  public Integer execute(IndexContext context) throws IOException {
    return context.getIndexReader().numDocs();
  }

  @Override
  public Long clusterExecute(ClusterContext context) throws IOException {
    Map<Shard, Integer> indexes = context.readIndexes(null, DocumentCountNoCombine.class);
    long total = 0;
    for (Entry<Shard, Integer> e : indexes.entrySet()) {
      total += e.getValue();
    }
    return total;
  }

}