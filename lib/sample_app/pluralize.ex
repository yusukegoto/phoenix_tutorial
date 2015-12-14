defmodule SampleApp.Pluralize do
  import Inflex

  def pluralize(count, name) do
    names = if count <= 1,
              do:   Inflex.singularize(name),
              else: Inflex.pluralize(name)
    "#{count} #{names}"
  end
end
