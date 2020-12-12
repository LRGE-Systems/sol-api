# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Doorkeeper::Application.create! uid:'idhash', secret: 'secrethash', name: 'Test', redirect_uri: 'http://localhost:8080/'

Admin.create email:"arueira95@gmail.com", password:"12345678", name:"Galba"

Doorkeeper::Application.find_or_create_by(name: 'sdc-admin-frontend.vue') do |app|
   app.attributes = {  
     confidential: false, # it's a webapp! Also, confidential apps must authenticate when revoking tokens!    
     uid: "idhash",    
     secret: "secrethash",    
     redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',    
     scopes: 'admin' # read write ...    
   }    
end

Doorkeeper::Application.find_or_create_by(name: 'sdc-cooperative-frontend.vue') do |app|
  app.attributes = {  
    confidential: false, # it's a webapp! Also, confidential apps must authenticate when revoking tokens!    
    uid: "sdc-cooperative-frontend.vue",    
    secret: "secretId",    
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',    
    scopes: 'user' # read write ...    
  }    
end


Doorkeeper::Application.find_or_create_by(name: 'sdc-supplier-frontend.vue') do |app|
  app.attributes = {  
    confidential: false, # it's a webapp! Also, confidential apps must authenticate when revoking tokens!    
    uid: "sdc-supplier-frontend.vue",    
    secret: "secretId",    
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',    
    scopes: 'supplier' # read write ...    
  }    
end