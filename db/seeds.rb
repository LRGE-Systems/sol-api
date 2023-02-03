# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
    {
        projectId: "P173743",
        name: "Sustainable and Resilient Rural Water and Sanitation Sector Support Project",
        country: 'Haiti',
        locale: "fr-FR",
        users:[
            {
                name: 'Khadija Faridi',
                email: 'kfaridi@worldbank.org'
            }
        ]
    },
    {
        projectId: "P178188",
        name: "Private Sector Jobs and Economic Transformation (PSJET)",
        country: 'Haiti',
        locale: "fr-FR",
        users:[
            {
                name: 'Vladimir Mathieu',
                email: 'vmathieu@worldbank.org'
            }
        ]
    },
    {
        projectId: "P174328",
        name: "Innovation for Rural Competitiveness Project - COMRURAL III",
        country: 'Honduras',
        locale: "es-PY",
        users:[
            {
                name: 'Maria Camila Padilla',
                email: 'mpadilla@worldbank.org'
            },
            {
                name: 'Catherine Abreu Rojas',
                email: 'zabreurojas@worldbank.org'
            }
        ]
    },
    {
        projectId: "P166279",
        name: "Second Rural Economic Development Initiative (REDI II) Project",
        country: 'Jamaica',
        locale: "en-US",
        users:[
            {
                name: 'Monique Frederica Harper Griffiths',
                email: 'mharpergriffiths@worldbank.org'
            },
            {
                name: 'Joao Guilherme Morais de Queiroz',
                email: 'jqueiroz@worldbank.org'
            },
            {
                name: 'Nancy Bikondo-Omosa',
                email: 'nbikondo@worldbank.org'
            }
        ]
    }
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
            locale: org[:locale]
        )
        user.password = 'sol@169!m'
        user.password_confirmation = 'sol@169!m'
        user.save!
    end
end