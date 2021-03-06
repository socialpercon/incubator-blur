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
package org.apache.blur.command;

import java.io.IOException;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.blur.command.commandtype.ClusterExecuteServerReadCommandSingleTable;

public class TestBlurObjectCommand extends ClusterExecuteServerReadCommandSingleTable<BlurObject> {

  @Override
  public BlurObject execute(IndexContext context) throws IOException {
    BlurObject blurObject = new BlurObject();
    blurObject.accumulate("docCount", context.getIndexReader().numDocs());
    return blurObject;
  }

  @Override
  public BlurObject combine(CombiningContext context, Map<? extends Location<?>, BlurObject> results)
      throws IOException, InterruptedException {
    BlurObject blurObject = new BlurObject();
    long total = 0;
    for (BlurObject bo : results.values()) {
      total += bo.getInteger("docCount");
    }
    blurObject.put("docCount", total);
    return blurObject;
  }

  @Override
  public BlurObject clusterExecute(ClusterContext context) throws IOException {
    BlurObject blurObject = new BlurObject();
    Map<Server, BlurObject> results = context.readServers(this);
    long total = 0;
    for (Entry<Server, BlurObject> e : results.entrySet()) {
      BlurObject value = e.getValue();
      Long count = value.getLong("docCount");
      total += count;
    }
    blurObject.put("docCount", total);
    return blurObject;
  }

  @Override
  public String getName() {
    return "testBlurObject";
  }

}
