# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:

InitiativeStatus.create! name: 'Initiation',
                         description:
                           'This could cover feasibility, initial mobilisation, brainstorming, etc.'
InitiativeStatus.create! name: 'Planning',
                         description:
                           'This assumes a core team assembled and feasibility issues resolved, and now preparing a plan or finding funding or similar activities.'
InitiativeStatus.create! name: 'Implementation',
                         description:
                           'This is where the project is being implemented and may include a number of project sub-stages. A complex project would benefit from having a full work break-down structure for this stage.'
InitiativeStatus.create! name: 'Operational',
                         description:
                           'For an operational venture, this is the hand-over from project mode to an operations mode for the venture in question. For some initiatives, they may be broken into PHASES so the completion of one phase, would precede the INITIATION of another phase.'
InitiativeStatus.create! name: 'Completed',
                         description:
                           'For a one off project this involves the closure of the project, during which a debrief and gathering of lessons would help in communicating results to others wishing to execute a similar project. For an operational venture, this is the hand-over from project mode to an operations mode for the venture in question. For some initiatives, they may be broken into PHASES so the completion of one phase, would precede the INITIATION of another phase.'
InitiativeStatus.create! name: 'Abandoned',
                         description:
                           'A project that has been abandoned is worth flagging, as we could learn lessons from it (was it lack of critical mass in uptakes? lack of trained resources? funding difficulties? … This status won’t say why, but maybe a chat with the Initiative owner could be useful to someone trying the start a similar initiatives.'

GroupType.create! name: 'Association'
GroupType.create! name: 'Charity'
GroupType.create! name: 'Community Benefit Society'
GroupType.create! name: 'Co-operative'
GroupType.create! name: 'Community Interest Company'
GroupType.create! name: 'Limited Company'
GroupType.create! name: 'Partnership'
GroupType.create! name: 'Public Body'
GroupType.create! name: 'Trust'
