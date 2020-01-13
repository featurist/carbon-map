# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

InitiativeStatus.create! name: 'In planning',
                         description: 'This covers the period after an idea has been formed and initial plans have been prepared, but before the initiative is ready to execute plans (team, funding, resources, permissions, designs, etc. in place).'

InitiativeStatus.create! name: 'In Development',
                         description: 'This covers the period where a detailed plan to implement the initiative has turned into action for an initiative: conducting a survey; building a community hall solar array; creating a community gardens service; or whatever. After this, an initiative will either be Running, Completed or Abandoned.'

InitiativeStatus.create! name: 'Running',
                         description: 'After creation of a service or operation, this indicates that it is running and will remain so indefinitely.'

InitiativeStatus.create! name: 'Completed',
                         description: 'If an initiative is neither a service nor operation - such as a one off survey or insulation project for a street - then once done, it moves to a completed state. End of story.'

InitiativeStatus.create! name: 'Abandoned',
                         description: 'An initiative that has been abandoned is worth flagging, as we could learn lessons from it. Either an In development initiative or a Running one could be Abandoned.'

GroupType.create! name: 'Association'
GroupType.create! name: 'Charity'
GroupType.create! name: 'Community Benefit Society'
GroupType.create! name: 'Co-operative'
GroupType.create! name: 'Community Interest Company'
GroupType.create! name: 'Limited Company'
GroupType.create! name: 'Partnership'
GroupType.create! name: 'Public Body'
GroupType.create! name: 'Trust'
GroupType.create! name: 'Other'

admin = User.new email: 'derek@spathi.com', role: 'admin'
admin.save!(validate: false)

solutions = CSV.read('./import/taxonomy.csv', headers: true)
solutions.each do |line|
  sector = Sector.find_or_create_by(name: line['sector'])
  theme = Theme.find_or_create_by(name: line['theme'], sector: sector)
  solution_class = SolutionClass.find_or_create_by(name: line['class'], theme: theme)
  solution = Solution.find_or_create_by(name: line['solution'], created_by: admin, status: 200)
  SolutionSolutionClass.create(solution: solution, solution_class: solution_class)
end

transition_stroud = admin.groups.create!(
  name: 'Transition Stroud',
  abbreviation: '_',
  contact_name: 'Paul Hoffman',
  contact_email: '_',
  contact_phone: '_',
  websites: [GroupWebsite.new(url: 'https://www.transitionstroud.org')]
)

carbon_reduction_map = admin.initiatives.build(
  name: 'Carbon Reduction Map',
  description_what: 'Connect people with initiatives',
  description_how: 'Create a map that allows people to find initiatives by location and solution',
  description_further_information: 'You are currently using this project',
  contact_name: 'Paul Hoffman',
  contact_email: '_',
  contact_phone: '_',
  status: InitiativeStatus.find_by(name: 'Running'),
  postcode: 'GL5 1DF',
  lead_group: transition_stroud,
  websites: [InitiativeWebsite.new(url: 'https://carbon-map.herokuapp.com')],
  longitude: -2.213281,
  latitude: 51.746861
)
carbon_reduction_map.themes.build(theme: Theme.find_by(name: 'Engagement'))

carbon_reduction_map.update_location_from_postcode
carbon_reduction_map.save!
