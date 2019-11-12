# frozen_string_literal: true

require 'test_helper'

# rubocop:disable all
class SolutionTest < ActiveSupport::TestCase
  test 'generates a hierarchy of solutions' do
    solution_hierarchy = Solution.hierarchy
    expected = [
      {
        name: 'Energy',
        themes: [
          {
            name: 'Heating',
            classes: [
              {
                name: 'Heat pumps',
                solution_class_id:
                  ActiveRecord::FixtureSet.identify('heat_pumps'),
                solutions: [
                  {
                    name: 'ASHP',
                    solution_id: ActiveRecord::FixtureSet.identify('ashp'),
                    solution_class_id:
                      ActiveRecord::FixtureSet.identify('heat_pumps')
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        name: 'Transport',
        themes: [
          {
            name: 'Lift Share',
            classes: [
              {
                name: 'Apps',
                solution_class_id: ActiveRecord::FixtureSet.identify('apps'),
                solutions: [
                  {
                    name: 'Lift Share App',
                    solution_id:
                      ActiveRecord::FixtureSet.identify('lift_share_app'),
                    solution_class_id: ActiveRecord::FixtureSet.identify('apps')
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
    assert_equal expected, solution_hierarchy
  end
end
# rubocop:enable all
