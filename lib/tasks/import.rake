require 'csv'

namespace :import do
  desc 'Run tests with coverage report'
  task taxonomy: :environment do
    #ap "hello"
    solutions = CSV.read('./import/taxonomy.csv', headers: true)
    solutions.each do |line|
      sector = Sector.find_or_create_by(name: line['sector'])
      theme = Theme.find_or_create_by(name: line['theme'], sector: sector)
      solution_class = SolutionClass.find_or_create_by(name: line['class'], theme: theme)
      solution = Solution.find_or_create_by(name: line['solution'])
      SolutionSolutionClass.create(solution: solution, solution_class: solution_class)
    end

  end
end

