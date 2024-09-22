defmodule PhxComponentsWeb.Home do
  use PhxComponentsWeb, :live_view

  alias PhxComponentsWeb.Cal

  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={Cal} id="component_calendar" />
    </div>
    """
  end
end
