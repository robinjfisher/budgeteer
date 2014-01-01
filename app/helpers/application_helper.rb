module ApplicationHelper
  
  def display(figure)
    figure.to_s.insert(-3,".")
  end
  
end
