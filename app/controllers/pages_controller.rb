class PagesController < ApplicationController
  before_filter :load_resources

  def game
  end

  def results
  end

  def questions
  end

protected
  def load_resources
    @cards = [
      {id: 1, title: "Lobbying for policy change", action: "Advocating"},
      {id: 2, title: "Influencing government and business priorities", action: "Advocating"},
      {id: 3, title: "Influencing public opinion", action: "Advocating"},
      {id: 4, title: "Promoting specific organizations and interventions", action: "Advocating"},
      {id: 5, title: "Providing direct support to local government", action: "Building Community Capacity"},
      {id: 6, title: "Growing local entrepreneurs and businesses", action: "Building Community Capacity"},
      {id: 7, title: "Promoting nonprofit organizational effectiveness", action: "Building Community Capacity"},
      {id: 8, title: "Developing the skills of local residents", action: "Building Community Capacity"},
      {id: 9, title: "Empowering resident decision-making", action: "Engaging The Community"},
      {id: 10, title: "Mobilizing residents around issues", action: "Engaging The Community"},
      {id: 11, title: "Providing avenues for community input, ideas and connection", action: "Engaging The Community"},
      {id: 12, title: "Facilitating civic participation and volunteerism", action: "Engaging The Community"},
      {id: 13, title: "Facilitating community dialogue", action: "Engaging The Community"},
      {id: 14, title: "Strengthening social connections among residents", action: "Engaging The Community"},
      {id: 15, title: "Proactively planning for the long term", action: "Community Planning"},
      {id: 16, title: "Facilitating urban/ rural planning processes", action: "Community Planning"},
      {id: 17, title: "Promoting economic development planning", action: "Community Planning"},
      {id: 18, title: "Planning for disaster response and prevention", action: "Community Planning"},
      {id: 19, title: "Soliciting giving from local donors (individual or institutional)", action: "Expanding Financial Capital"},
      {id: 20, title: "Soliciting capital from outside the community", action: "Expanding Financial Capital"},
      {id: 21, title: "Deliberately attracting diverse donors", action: "Expanding Financial Capital"},
      {id: 22, title: "Educating the public about philanthropy", action: "Expanding Financial Capital"},
      {id: 23, title: "Developing earned income to support social-purpose activities", action: "Expanding Financial Capital"},
      {id: 24, title: "Facilitating learning networks", action: "Aligning Action"},
      {id: 25, title: "Managing formal collaborations", action: "Aligning Action"},
      {id: 26, title: "Coordinating funding and activities", action: "Aligning Action"},
      {id: 27, title: "Building collaboratives", action: "Aligning Action"},
      {id: 28, title: "Incubating social enterprises or businesses", action: "Direct Service & Programming"},
      {id: 29, title: "Starting new nonprofit programs", action: "Direct Service & Programming"},
      {id: 30, title: "Managing direct service programs", action: "Direct Service & Programming"},
      {id: 31, title: "Designing government interventions", action: "Direct Service & Programming"},
      {id: 32, title: "Managing government programs", action: "Direct Service & Programming"},
      {id: 33, title: "Impact investing", action: "Deploying Financial Capital"},
      {id: 34, title: "Supporting individuals (scholarships, fellowships, etc.)", action: "Deploying Financial Capital"},
      {id: 35, title: "Grantmaking to nonprofits", action: "Deploying Financial Capital"},
      {id: 36, title: "Directly connecting givers and recipients", action: "Deploying Financial Capital"},
      {id: 37, title: "Managing transactions for donors", action: "Financial & Donor Services"},
      {id: 38, title: "Educating donors about community issues", action: "Financial & Donor Services"},
      {id: 39, title: "Managing investments/ endowment funds", action: "Financial & Donor Services"},
      {id: 40, title: "Providing philanthropic advisory services", action: "Financial & Donor Services"},
      {id: 41, title: "Connecting local philanthropists with each other", action: "Financial & Donor Services"},
      {id: 42, title: "Co-creating initiatives with donors", action: "Financial & Donor Services"},
      {id: 43, title: "Tracking data about community well-being", action: "Sharing Community Information"},
      {id: 44, title: "Compiling information about local organizations and available resources", action: "Sharing Community Information"},
      {id: 45, title: "Researching community issues and public policy", action: "Sharing Community Information"},
      {id: 46, title: "Measuring the outcomes and impacts of programs", action: "Sharing Community Information"},
      {id: 47, title: "Spreading local news", action: "Sharing Community Information"}
    ]
  end
end
