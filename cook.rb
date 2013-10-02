#!/usr/bin/env ruby

require 'haml'
require 'erb'
require 'active_support/inflector'
require 'yaml'


class Object
  attr_accessor :action
  attr_accessor :actions
  attr_accessor :cached_data
end


def render name
  Haml::Engine.new(File.read "#{name}.haml").render self
end

def data name
  cached_data[name] ||= YAML::load_file "data/#{name}.yml"
end

def view name
  index_erb = ERB.new File.read 'index.html.erb'
  self.action = name
  File.open "#{name}.html", 'w' do |f|
    f.write index_erb.result binding
  end
end

self.cached_data = {}
self.actions = [ 'index', 'contacts' ]
self.actions.each { |name| view name }

