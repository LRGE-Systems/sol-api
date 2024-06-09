namespace :sol_sample_users do
    desc 'make demo users fast'
    task setup: :environment do |task|
        Organization.find_or_create_by! name: "DemoOrg", locale: "en-US", country: "US", projectId: "00"
        a = Admin.find_by locale: "en-US", email: "demouser@mail.com", role: :general, name: "Demo Admin SOL", organization_id: 1
        if a.blank?
            Admin.create! locale: "en-US",password: "12345678" , email: "demouser@mail.com", role: :general, name: "Demo Admin SOL", organization_id: 1
            
        end

        pr = Individual.find_or_create_by! organization_id: 1, name: "Demo Provider", document: 1
        if pr.blank?
            Individual.find_or_create_by! organization_id: 1, name: "Demo Provider", document: 1,  provider_classifications_attributes: [{classification: Classification.last}]
        end

        b = Supplier.find_by provider: pr, cpf:"689.061.720-79", phone: "(22) 22222-2222", locale: "en-US", email: "demouser@mail.com", name: "Demo Admin SOL", organization_id: 1
        if b.blank?
            Supplier.create! provider: pr, password: "12345678" , cpf:"689.061.720-79", phone: "(22) 22222-2222", locale: "en-US", email: "demouser@mail.com",  name: "Demo Admin SOL", organization_id: 1
        end

        coop = Cooperative.find_or_create_by! organization_id:1, name: "Coop Demo", cnpj: "19.021.592/0001-56"
        if coop.blank?
            Cooperative.find_or_create_by! organization_id:1, name: "Coop Demo", cnpj: "19.021.592/0001-56", legal_representative_attributes: {cpf: "444.877.150-40", name: "LegalRpDemo", nationality: "BR", civil_state: :single, rg: "50.992.740-3"}, address_attributes: {number: 1, neighborhood: "demo", reference_point: "demo", cep: "28080-210", latitude: -21, longitude: -43, city: City.last, address: "Rua pastor x"}
        end

        c = User.find_by cooperative: coop, cpf:"854.589.240-37", locale: "en-US", email: "demouser@mail.com", name: "Demo Admin SOL", organization_id: 1
        if c.blank?
            User.create! cooperative: coop, password: "12345678" , cpf:"854.589.240-37", locale: "en-US", email: "demouser@mail.com", name: "Demo Admin SOL", organization_id: 1
        end
        puts "\nCREATED USER AND ORGANIZATION"
        puts "::Admin::"
        puts "Email: demouser@mail.com"
        puts "Password: 12345678\n"

        puts "::Supplier::"
        puts "Email: demouser@mail.com"
        puts "Password: 12345678\n"

        puts "::User::"
        puts "Email: demouser@mail.com"
        puts "Password: 12345678\n"
    end
end
