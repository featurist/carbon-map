# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:

InitiativeStatus.create! name: 'In planning',
                         description: 'This covers the period after an idea has been formed and initial plans have been prepared, but before the initiative is ready to execute plans (team, funding, resources, permissions, designs, etc. in place).'

InitiativeStatus.create! name: 'In planning',
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

User.create! email: 'admin@test.com', password: 'password', role: 'admin'
User.create! email: 'dev@test.com', password: 'password', role: 'consumer'
