# frozen_string_literal: true

root_path = File.expand_path("../../", __FILE__)
$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)

require 'db/connection'
