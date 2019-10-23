# frozen_string_literal: true

require 'test_helper'

# rubocop:disable all
class SolutionTest < ActiveSupport::TestCase
  test 'generates a flat list of solutions' do
    solutions = Solution.all_flattened
    assert_equal 2, solutions.size
    expected_solution1 = {
      solution: 'ASHP', class: 'Heat pumps', theme: 'Heating', sector: 'Energy'
    }
    expected_solution2 = {
      solution: 'Lift Share App',
      class: 'Apps',
      theme: 'Lift Share',
      sector: 'Transport'
    }
    assert_equal expected_solution1,
                 solutions[0].except(:solution_id, :class_id)
    assert_equal expected_solution2,
                 solutions[1].except(:solution_id, :class_id)
  end

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
