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
package org.apache.blur.trace;

public class TracerImpl implements Tracer {

  protected final String _name;
  protected final long _start;
  protected long _ended;
  protected final String _threadName;
  protected final long _id;
  protected final long _parentThreadId;

  public TracerImpl(String name, long id, long parentThreadId) {
    _name = name;
    _start = System.nanoTime();
    _threadName = Thread.currentThread().getName();
    _id = id;
    _parentThreadId = parentThreadId;
  }

  @Override
  public void done() {
    _ended = System.nanoTime();
  }

  @Override
  public String toString() {
    return "Tracer [name=" + _name + ", id=" + _id + ", thread=" + _threadName + ", started=" + _start + ", took="
        + (_ended - _start) + " ns]";
  }

  public String getName() {
    return _name;
  }

  public long getStart() {
    return _start;
  }

  public long getEnded() {
    return _ended;
  }

  public String getThreadName() {
    return _threadName;
  }

  public String toJson() {
    return "{\"id\"=" + _id + ", \"parentThread\"=" + _parentThreadId + ", \"name\"=\"" + _name + "\", \"thread\"=\""
        + _threadName + "\", \"took\"=" + (_ended - _start) + ", \"started\"=" + _start + ", \"ended\"=" + _ended + "}";
  }

}