# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end

puts'ORGANIZATIONS'
org = Organization.find_or_create_by_name name: 'Org 1', description: 'Sample org', active: true
puts 'organization: ' << org.name

puts 'DEFAULT USERS'
puts 'SysAdmin User'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.confirm!
user.add_role :sys_admin

puts 'MEMBERSHIPS'
membership = org.membership_types.create name: 'Regular'

puts 'Org1 OrgAdmin User'
user2 = User.find_or_create_by_email :name => 'Org1 Admin', :email => 'org1admin@example.com', :password => 'changeme', :password_confirmation => 'changeme'
user.confirm!
user2.memberships.create! organization_id: org.id, expires_at: (Date.today + 1.year), membership_type: membership
puts 'user2: ' << user2.name
user2.add_role :org_admin, Organization.first
