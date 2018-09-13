require ('mysql2')
namespace :db do
  desc 'create 0ch database'
  task :create_database do
    puts '>> call create zero_ch database'
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    client.query('create database IF NOT EXISTS zero_ch')
    puts '<< created zero_ch database'
  end

  desc 'create threads table'
  task :create_threads do
    puts '>> call create threads table'
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root')
    contents = {
      id: 'INT NOT NULL auto_increment PRIMARY KEY',
      title: 'CHARACTER(255)'
    }
    sql = 'CREATE TABLE IF NOT EXISTS zero_ch.threads (' +
      contents.map{|k,v| "#{k} #{v}" }.join(',') + 
      ') DEFAULT CHARSET=utf8;'
    client.query(sql)
    puts '<< created threads table'
  end

  desc 'create posts'
  task :create_posts do
    puts '>> call create posts table' 
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
    puts '<< created posts table' 
  end
end
