# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
    {
        projectId: "CGL - SEGEP",
        name: "CGL - SEGEP",
        country: 'Brazil',
        locale: "pt-BR",
        users:[
            {
                name: 'SILVIO NAZARENO LEAL COSTA',
                email: 'silviocosta.leal@gmail.com',
                phone: "98406-8587"
            },
            {
                name: 'CRYSTHIAN ELAINE OLIVEIRA DA SILVA',
                email: 'crysthianelaine@gmail.com',
                phone: "98291-2108"
            },
            {
                name: 'ALEX FERREIRA SOLON',
                email: 'solonalex21@gmail.com',
                phone: "98838-7257"
            },
            {
                name: 'MONIK SILVEIRA MEIRA MATTOS',
                email: 'moniksilveira@hotmail.com',
                phone: "98118-7934"
            },
            {
                name: 'JOSÉ GUEDES DA COSTA JÚNIOR',
                email: 'cglpregoeiro@gmail.com',
                phone: "98118-4559"
            },
            {
                name: 'ADRIANA LEAL BRUM',
                email: 'adrianabrum2006@gmail.com',
                phone: "99241-5517"
            },
            {
                name: 'MONICA MEIRELES FRANCO',
                email: 'monica@mocajuba.com',
                phone: "98163-1650"
            },
            {
                name: 'MARCELO CANTÃO LOPES',
                email: 'marcellolopes1418@gmail.com',
                phone: "99244-5925"
            },
            {
                name: 'ISIS SOUZA COIMBRA',
                email: 'isis_coimbra@yahoo.com.br',
                phone: "98220-8240"
            },
            {
                name: 'OTAVIO SOCORRO BAIA',
                email: 'cgl.pregoeiro33@gmail.com',
                phone: "98112-6730"
            },
            {
                name: 'LIDIANE ANDRADE CUNHA',
                email: 'landradeamim@gmail.com',
                phone: "98408-1537"
            },
            {
                name: 'CLAUDINE SARMANHO FERREIRRA',
                email: 'claudine.ferreira2@gmail.com',
                phone: "98354-3113"
            },
        ]
    },
].each do |ac|
    org = Organization.where(
        projectId: ac[:projectId],
        name: ac[:name],
        country: ac[:country],
        locale: ac[:locale]
    ).first_or_create!
    ac[:users].each do |cm|
        user = Admin.find_or_initialize_by(
            organization: org,
            email: cm[:email],
            name: cm[:name],
            locale: org[:locale],
            phone: cm[:phone]
        )
        user.password = 'solcaru@1234#!admincaru'
        user.password_confirmation = 'sol@1234#!admincaru'
        user.save!
    end
end