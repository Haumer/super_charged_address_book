class Group < ApplicationRecord
  belongs_to :user
  has_many :group_contacts, dependent: :destroy
  has_many :contacts, through: :group_contacts

  COLORS = [
    ["Persian Pink", "#EB7BC0"],
    ["Mauve", "#DBBBF5"],
    ["Periwinkle", "#BBBDF6"],
    ["Tropical Indigo", "#9593D9"],
    ["Celestial Blue", "#20A4F3"],
    ["Delft Blue", "#414770"],
    ["YlnMn Blue", "#345995"],
    ["Russian Violet", "#372248"],
    ["Burgundy", "#74121D"],
    ["Vermillion", "#FF312E"],
    ["Orange peel", "#FFA737"],
    ["Maize", "#FEE440"],
    ["Vanilla", "#FFF7AE"],
    ["Light green", "#C1FF9B"],
    ["Matis", "#6CC551"],
    ["Avocado", "#447604"],
  ]
end
