class PagesController < ApplicationController
  before_filter :load_resources, only: [:game, :results]

  def game
  end

  def results
  end

  def registration
    @user_ip = remote_ip()
    # raise @user_ip
  end

  def questions
  end

protected
  def load_resources
    @cards = [
      {id: 1, title: "Lobbying for policy change", action: "Advocating", copy: "Attempting to influence policy decisions made by officials in the government."},
      {id: 2, title: "Influencing government and business priorities", action: "Advocating", copy: "Working to change the operations or allocation of a local government or business resources."},
      {id: 3, title: "Influencing public opinion", action: "Advocating", copy: "Raising awareness and changing prevailing attitudes and beliefs about important local issues, causes, and policies."},
      {id: 4, title: "Promoting specific organizations and interventions", action: "Advocating", copy: "Publicly encouraging support for particular local institutions and their programs."},
      {id: 5, title: "Providing direct support to local government", action: "Building Community Capacity", copy: "Helping elected representatives and government agencies more effectively provide services and support to local communities."},
      {id: 6, title: "Growing local entrepreneurs and businesses", action: "Building Community Capacity", copy: "Providing training and other support to people who are starting business ventures in the community."},
      {id: 7, title: "Promoting nonprofit organizational effectiveness", action: "Building Community Capacity", copy: "Helping nonprofits build skills and capacity to better deliver programs and achieve intended outcomes."},
      {id: 8, title: "Developing the skills of local residents", action: "Building Community Capacity", copy: "Helping community members develop skills and capabilities that help them become more engaged and productive members of their community."},
      {id: 9, title: "Empowering resident decision-making", action: "Engaging The Community", copy: "Giving local residents greater voice and control over resource allocation decisions."},
      {id: 10, title: "Mobilizing residents around issues", action: "Engaging The Community", copy: "Organizing the efforts of community members to help them advocate on behalf of their own interests."},
      {id: 11, title: "Providing avenues for community input, ideas and connection", action: "Engaging The Community", copy: "Creating channels for residents to contribute their ideas and plan community action."},
      {id: 12, title: "Facilitating civic participation and volunteerism", action: "Engaging The Community", copy: "Providing opportunities for residents to get involved and engaged in efforts to improve their communities."},
      {id: 13, title: "Facilitating community dialogue", action: "Engaging The Community", copy: "Catalyzing a process that allows residents to voice their opinions and engage in discussions about local issues."},
      {id: 14, title: "Strengthening social connections among residents", action: "Engaging The Community", copy: "Creating opportunities for local residents to interact and build relationships and trust."},
      {id: 15, title: "Proactively planning for the long term", action: "Community Planning", copy: "Deliberately anticipating and addressing issues that might affect the community in the future and that may not currently be on the public agenda."},
      {id: 16, title: "Facilitating urban/ rural planning processes", action: "Community Planning", copy: "Helping to design and guide the physical development of both urban, suburban, and rural communities."},
      {id: 17, title: "Promoting economic development planning", action: "Community Planning", copy: "Supporting efforts to guide and promote the development of the local economy."},
      {id: 18, title: "Planning for disaster response and prevention", action: "Community Planning", copy: "Developing procedures and processes for avoiding and responding to environmental and man-made disasters."},
      {id: 19, title: "Soliciting giving from local donors (individual or institutional)", action: "Expanding Financial Capital", copy: "Raising financial and other types of capital (e.g., real estate, farmland, water rights) from local individuals and institutions."},
      {id: 20, title: "Soliciting capital from outside the community", action: "Expanding Financial Capital", copy: "Raising financial and other types of capital from individuals and institutions located outside the geographic boundaries of the community."},
      {id: 21, title: "Deliberately attracting diverse donors", action: "Expanding Financial Capital", copy: "Raising funds in a targeted way from groups of people who have traditionally been underrepresented in your donor base."},
      {id: 22, title: "Educating the public about philanthropy", action: "Expanding Financial Capital", copy: "Raising awareness and teaching residents about the practice of giving financial and other assets to improve the community."},
      {id: 23, title: "Developing earned income to support social-purpose activities", action: "Expanding Financial Capital", copy: "Leveraging donated assets or creating new service lines in order to generate revenue for your organization."},
      {id: 24, title: "Facilitating learning networks", action: "Aligning Action", copy: "Helping a network of organizations or individuals learn together about local challenges and potential solutions."},
      {id: 25, title: "Managing formal collaborations", action: "Aligning Action", copy: "Overseeing the strategy and day-to-day functioning of a group of stakeholders that are working together."},
      {id: 26, title: "Coordinating funding and activities", action: "Aligning Action", copy: "Helping individuals and institutions align effort and resources so that their impact has the potential to be greater than the sum of their parts."},
      {id: 27, title: "Building collaboratives", action: "Aligning Action", copy: "Bringing together multiple stakeholders to work collaboratively on particular issues."},
      {id: 28, title: "Incubating social enterprises or businesses", action: "Direct Service & Programming", copy: "Spearheading the creation of social-purpose ventures or other types of local businesses."},
      {id: 29, title: "Starting new nonprofit programs", action: "Direct Service & Programming", copy: "Launching or incubating a social service program that addresses an unmet community need."},
      {id: 30, title: "Managing direct service programs", action: "Direct Service & Programming", copy: "Overseeing the day-to- day functioning of a social service program that addresses a local need or issue."},
      {id: 31, title: "Designing government interventions", action: "Direct Service & Programming", copy: "Helping government agencies develop effective public service programs that address key community needs and problems."},
      {id: 32, title: "Managing government programs", action: "Direct Service & Programming", copy: "Overseeing the day-to-day functioning of a public service program traditionally provided by the government."},
      {id: 33, title: "Impact investing", action: "Deploying Financial Capital", copy: "Making investments that generate social and environmental impact as well as financial returns."},
      {id: 34, title: "Supporting individuals (scholarships, fellowships, etc.)", action: "Deploying Financial Capital", copy: "Providing financial and other types of capital to residents (e.g., scholarships and fellowships)."},
      {id: 35, title: "Grantmaking to nonprofits", action: "Deploying Financial Capital", copy: "Disbursing grants to nonprofits and registered charities."},
      {id: 36, title: "Directly connecting givers and recipients", action: "Deploying Financial Capital", copy: "Creating platforms that allow residents to give directly to causes, organizations, and individuals."},
      {id: 37, title: "Managing transactions for donors", action: "Financial & Donor Services", copy: "Overseeing the transfer of funds from donors to recipients."},
      {id: 38, title: "Educating donors about community issues", action: "Financial & Donor Services", copy: "Teaching philanthropists about issues and policies that are affecting the community."},
      {id: 39, title: "Managing investments/ endowment funds", action: "Financial & Donor Services", copy: "Investing endowed or nonendowed assets to generate financial returns."},
      {id: 40, title: "Providing philanthropic advisory services", action: "Financial & Donor Services", copy: "Helping donors clarify their philanthropic intentions and offering guidance and specific recommendations to assist them with their giving."},
      {id: 41, title: "Connecting local philanthropists with each other", action: "Financial & Donor Services", copy: "Creating opportunities for donors to connect, discuss ideas, volunteer, and otherwise build and strengthen relationships."},
      {id: 42, title: "Co-creating initiatives with donors", action: "Financial & Donor Services", copy: "Working collaboratively with donors to design new approaches, initiatives, or programs that are aligned with their interests."},
      {id: 43, title: "Tracking data about community well-being", action: "Sharing Community Information", copy: "Measuring and sharing information about critical indicators of community health, well-being, and quality of life."},
      {id: 44, title: "Compiling information about local organizations and available resources", action: "Sharing Community Information", copy: "Aggregating and sharing information about available government and nonprofit service providers."},
      {id: 45, title: "Researching community issues and public policy", action: "Sharing Community Information", copy: "Investigating and building knowledge about topics of importance to the community."},
      {id: 46, title: "Measuring the outcomes and impacts of programs", action: "Sharing Community Information", copy: "Assessing the effects and impacts that different interventions are having on people, organizations, and the broader environment."},
      {id: 47, title: "Spreading local news", action: "Sharing Community Information", copy: "Creating and sharing information about what is happening in the community across a variety of different media platforms (e.g., Web, television, print, radio)."}
    ]
  end
end