# frozen_string_literal: true

# Copyright 2016-2017 New Context Services, Inc.
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

require "support/kitchen/terraform/config_attribute_context"

::RSpec
  .shared_examples "Kitchen::Terraform::ConfigAttribute::LockTimeout" do
    include_context(
      "Kitchen::Terraform::ConfigAttribute",
      attribute: :lock_timeout
    ) do
      context "when the config omits :lock_timeout" do
        it_behaves_like(
          "a default value is used",
          default_value: "0s"
        )
      end

      context "when the config associates :lock_timeout with a nonstring" do
        it_behaves_like(
          "the value is invalid",
          error_message: /lock_timeout.*must be a string/,
          value: 123
        )
      end

      context "when the config associates :command_timeout with a string" do
        it_behaves_like(
          "the value is valid",
          value: "abc"
        )
      end
    end
  end
