# frozen_string_literal: true

class Solution < ApplicationRecord
  has_many :solution_solution_classes, dependent: :destroy

  def self.deep_load_solutions
    Solution.all.includes(
      solution_solution_classes: { solution_class: { theme: :sector } }
    )
  end

  def self.hierarchy
    hierarchy = []
    deep_load_solutions.find_each do |s|
      s.solution_solution_classes.each do |sc|
        sector = populate_sector(hierarchy, sc.solution_class)
        theme = populate_theme(sector, sc.solution_class)
        solution_class = populate_solution_class(theme, sc.solution_class.name)
        populate_solution(solution_class, sc.solution, sc.solution_class)
      end
    end
    hierarchy
  end

  def self.populate_sector(hierarchy, solution_class)
    name = solution_class.theme.sector.name
    sector = hierarchy.find { |s| s[:name] == name }
    if sector.nil?
      sector = { name: name, themes: [] }
      hierarchy << sector
    end
    sector
  end

  def self.populate_theme(sector, solution_class)
    name = solution_class.theme_name
    themes = sector[:themes]
    theme = themes.find { |t| t[:name] == name }
    if theme.nil?
      theme = { name: name, classes: [] }
      sector[:themes] << theme
    end
    theme
  end

  def self.populate_solution_class(theme, name)
    solution_class = theme[:classes].find { |t| t[:name] == name }
    if solution_class.nil?
      solution_class = { name: name, solutions: [] }
      theme[:classes] << solution_class
    end
    solution_class
  end

  def self.populate_solution(mapped_solution_class, solution, solution_class)
    name = solution.name
    solution = {
      name: name, solution_class_id: solution_class.id, solution_id: solution.id
    }
    mapped_solution_class[:solutions] << solution
  end
end
