# frozen_string_literal: true

# Copyright 2016 New Context Services, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "delegate"
require "kitchen"
require "kitchen/terraform/deprecating"
require "thread"

# This class provides the deprecating change to the KitchenInstance.
class ::Kitchen::Terraform::Deprecating::KitchenInstance < DelegateClass ::Kitchen::Instance

  # Runs a given action block directly.
  #
  # If the desired action is one of +:create+, +:converge+, +:setup+, or +:destroy+, and there is more than one thread
  # active, then a warning is issued about deprecating support for concurrency with the desired action.
  #
  # @api private
  # @param action [::Symbol] the action to be performed
  # @param state [::Hash] a mutable state hash for this instance
  # @see ::Kitchen::Instance
  # @yieldparam state [::Hash] a mutable state hash for this instance
  def synchronize_or_call(action, state)
    Array(
      driver
        .class
        .serial_actions
    )
      .grep action do |serial_action|
        ::Thread
          .list
          .length
          .>(1) and
            warn(
              "DEPRECATING: #{to_str} is about to invoke #{driver.class}##{serial_action} with concurrency " \
                "activated; this action will be forced to run serially as of Kitchen-Terraform v4.0.0"
            )
      end

    yield state
  end
end
