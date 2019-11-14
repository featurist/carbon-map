# frozen_string_literal: true

require 'csv'

namespace :import do
  desc 'Import taxonomy from csv'
  task taxonomy: :environment do
    solutions = CSV.read('./import/taxonomy.csv', headers: true)
    solutions.each do |line|
      sector = Sector.find_or_create_by(name: line['sector'])
      theme = Theme.find_or_create_by(name: line['theme'], sector: sector)
      solution_class = SolutionClass.find_or_create_by(name: line['class'], theme: theme)
      solution = Solution.find_or_create_by(name: line['solution'], created_by: User.first, status: 200)
      SolutionSolutionClass.create(solution: solution, solution_class: solution_class)
    end
  end
end
