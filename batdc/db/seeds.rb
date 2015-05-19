# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

roles = [{name: 'new'},
         {name: 'admin'},
         {name: 'authorized'}]
Role.create(roles)


functions = [{role: 'Not Specified'},
             {role: 'Academic Dean'},
             {role: 'Assistant Head of School'},
             {role: 'Assistant Division Head'},
             {role: 'Athletic Director'},
             {role: 'Dean of Faculty'},
             {role: 'Dean of Students/Student Life'},
             {role: 'Dean of Community/Inclusion/Diversity'},
             {role: 'Director of Admissions'},
             {role: 'Director of Alumni Relations'},
             {role: 'Director of Communications'},
             {role: 'Director of Development/Advancement'},
             {role: 'Director of Teaching and Learning'},
             {role: 'Director of Technology/Innovation'},
             {role: 'Head of School'},
             {role: 'Lower School Division Head'},
             {role: 'Middle School Division Head'},
             {role: 'Upper School Division Head'},
             {role: 'Administrative Assistant'},
             {role: 'Administrative Assistant to the Head'},
             {role: 'Admissions Associate'},
             {role: 'After School and Summer Programs Coordinator'},
             {role: 'Alumni Relations Associate'},
             {role: 'Athletic Department Associate'},
             {role: 'Business Manager'},
             {role: 'Business Associate'},
             {role: 'Class/Grade Dean'},
             {role: 'College Counselor'},
             {role: 'Communications Associate'},
             {role: 'Counselor/Psychologist'},
             {role: 'Development/Advancement Associate'},
             {role: 'Health/Wellness Coordinator'},
             {role: 'Learning Specialist'},
             {role: 'Librarian'},
             {role: 'Registrar'},
             {role: 'Service Learning/Community Service Coordinator'},
             {role: 'Technology/Media Staff'},
             {role: 'Teacher'},
             {role: 'Department Chair and Teacher'},
             {role: 'Teaching Assistant/Intern'},
            ]
Function.create(functions)

