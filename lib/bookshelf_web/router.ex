defmodule BookshelfWeb.Router do
  use BookshelfWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BookshelfWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BookshelfWeb do
    pipe_through :browser

    get "/", BasicDisplayController, :index
    post "/", BasicDisplayController, :index

    get "/custom-styles", CustomStylesController, :index
    post "/custom-styles", CustomStylesController, :index
    get "/design", DesignController, :index

    live "/live-filter", LiveFilterLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookshelfWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:bookshelf, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BookshelfWeb.Telemetry
    end
  end
end
