require 'mysql2'
require 'faker'
require 'pry'

namespace :db do
  desc 'set up database'
  task :setup do
    Rake::Task["db:create_database"].execute
    Rake::Task["db:create_threads"].execute
    Rake::Task["db:create_posts"].execute
    Rake::Task["db:seed"].execute
  end

  desc 'create 0ch database'
  task :create_database do
    puts '>> [CALL] create zero_ch database'
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    client.query('create database IF NOT EXISTS zero_ch')
    puts '<< [DONE] created zero_ch database'
  end

  desc 'create threads table'
  task :create_threads do
    puts '>> [CALL] create threads table'
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    contents = {
      id: 'INT NOT NULL auto_increment PRIMARY KEY',
      title: 'CHARACTER(255)'
    }
    sql = 'CREATE TABLE IF NOT EXISTS zero_ch.threads (' +
      contents.map{|k,v| "#{k} #{v}" }.join(',') + 
      ') DEFAULT CHARSET=utf8;'
    client.query(sql)
    puts '<< [DONE] created threads table'
  end

  desc 'create posts'
  task :create_posts do
    puts '>> [CALL] create posts table' 
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    contents = {
      id: 'INT NOT NULL auto_increment PRIMARY KEY',
      thread_id: 'INT NOT NULL',
      user_name: 'CHARACTER(255) NOT NULL',
      message: 'CHARACTER(255) NOT NULL'
    }
    sql = 'CREATE TABLE IF NOT EXISTS zero_ch.posts (' +
      contents.map{|k,v| "#{k} #{v}" }.join(',') +
      ') DEFAULT CHARSET=utf8;'
    client.query(sql)
    puts '<< [DONE] created posts table' 
  end

  desc 'insert seed'
  task :seed do
    Rake::Task["db:threads_seed"].execute
    Rake::Task["db:posts_seed"].execute
  end

  desc 'insert threads seed'
  task :threads_seed do
    puts '>> [CALL] create seed threads table'
    Faker::Config.locale = :ja
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    sql = "INSERT INTO zero_ch.threads(title) VALUES ('#{Faker::Lorem.sentence}')"
    client.query(sql)
    puts '<< [DONE] created seed threads table'
  end


  desc 'insert posts seed'
  task :posts_seed do
    puts '>> [CALL] create seed posts table'
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    sql = "SELECT COUNT(*) FROM zero_ch.threads"
    posts_count = client.query(sql).first["COUNT(*)"]
    25.times { Rake::Task["db:post_seed"].execute(posts_count) }
    puts '<< [DONE] created seed posts table'
  end
  
  desc 'insert one post seed'
  task :post_seed, [:posts_count] => :environment do |task, posts_count|
    Faker::Config.locale = :ja
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    sql = "INSERT INTO zero_ch.posts" +
      "(thread_id, user_name, message)" +
      "VALUES (#{rand(1..posts_count)}, '#{Faker::Name.name}', '#{Faker::Lorem.sentence}')"
    client.query(sql)
  end

  desc 'drop table'
  task :drop do
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    client.query("DROP TABLES zero_ch.threads")
    client.query("DROP TABLES zero_ch.posts")
  end
end
