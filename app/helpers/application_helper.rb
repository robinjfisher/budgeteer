# encoding: utf-8

module ApplicationHelper
  
  def display(figure)
    if figure > 0
      figure.to_s.insert(-3,".").insert(0,"£")
    elsif figure < 0
      figure.to_s.insert(-3,".").insert(1,"£")
    elsif figure == 0
      figure.to_s.insert(0,"£")
    end
  end
  
end
