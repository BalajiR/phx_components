defmodule PhxComponentsWeb.Cal do
  use PhxComponentsWeb, :live_component

  @week_starting_on :sunday
  @events [
    %{
      on: ~U[2024-01-12 05:21:38Z],
      title:
        "elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus"
    },
    %{
      on: ~U[2024-01-22 23:26:03Z],
      title:
        "elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit"
    },
    %{
      on: ~U[2024-01-13 18:47:25Z],
      title: "nunc proin at turpis a pede posuere nonummy integer non velit donec diam"
    },
    %{
      on: ~U[2024-01-04 07:50:39Z],
      title: "nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac"
    },
    %{
      on: ~U[2024-01-15 09:40:58Z],
      title:
        "justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed"
    },
    %{
      on: ~U[2024-01-08 00:06:53Z],
      title:
        "lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales"
    },
    %{
      on: ~U[2024-01-04 19:30:20Z],
      title:
        "dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit"
    },
    %{
      on: ~U[2024-01-27 02:44:54Z],
      title:
        "porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper"
    },
    %{
      on: ~U[2024-01-01 04:21:33Z],
      title:
        "metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus"
    },
    %{
      on: ~U[2024-01-06 21:39:07Z],
      title: "sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi"
    },
    %{
      on: ~U[2024-01-02 16:46:37Z],
      title: "congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae"
    },
    %{
      on: ~U[2024-01-12 16:26:26Z],
      title: "sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui"
    },
    %{
      on: ~U[2024-01-19 01:09:10Z],
      title:
        "lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante"
    },
    %{
      on: ~U[2024-01-08 10:55:14Z],
      title:
        "vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien"
    },
    %{
      on: ~U[2024-01-29 15:21:21Z],
      title:
        "tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec"
    }
  ]

  def mount(socket) do
    {:ok,
     socket
     |> assign(active_date: Date.utc_today())
     |> assign(events: @events)
     |> assign_rows}
  end

  def handle_event("prev_month", _params, socket) do
    {:noreply,
     socket
     |> update(:active_date, &(&1 |> Date.beginning_of_month() |> Date.add(-1)))
     |> assign_rows}
  end

  def handle_event("today", _params, socket) do
    {:noreply,
     socket
     |> assign(active_date: Date.utc_today())
     |> assign_rows}
  end

  def handle_event("next_month", _params, socket) do
    {:noreply,
     socket
     |> update(:active_date, &(&1 |> Date.end_of_month() |> Date.add(1)))
     |> assign_rows}
  end

  defp assign_rows(%{assigns: %{active_date: active_date}} = socket) do
    begins_at =
      active_date |> Date.beginning_of_month() |> Date.beginning_of_week(@week_starting_on)

    ends_at = active_date |> Date.end_of_month() |> Date.end_of_week(@week_starting_on)
    rows = Date.range(begins_at, ends_at) |> Enum.chunk_every(7)

    # this is to show same # of weeks / rows for every month
    updated_ends_at =
      if Enum.count(rows) < 6 do
        ends_at |> Date.add(1) |> Date.end_of_week(@week_starting_on)
      else
        ends_at
      end

    assign(socket, rows: Date.range(begins_at, updated_ends_at) |> Enum.chunk_every(7))
  end

  defp day_belongs_to_other_month?(day, active_date) do
    Date.beginning_of_month(day) !== Date.beginning_of_month(active_date)
  end

  defp events_for_day(day, events) do
    events
    |> Enum.filter(&(Date.compare(day, &1.on) == :eq))
  end

  defp cal_header(assigns) do
    ~H"""
    <div class="flex items-center justify-between bg-gray-50 p-4">
      <div class="font-semibold text-xl" id="month_info">
        <%= Calendar.strftime(@date, "%B %Y") %>
      </div>
      <div>
        <div class="flex h-9 w-fit shadow-sm">
          <button
            class="flex w-9 items-center rounded-l border-y border-l border-gray-300 bg-white px-1.5 text-gray-400 hover:bg-gray-100"
            phx-click="prev_month"
            phx-target={@target}
          >
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none" />
              <path d="M15 6l-6 6l6 6" />
            </svg>
          </button>
          <button
            class="border-y border-gray-300 bg-white px-3 text-sm font-bold text-slate-800 hover:bg-gray-100"
            phx-click="today"
            phx-target={@target}
          >
            Today
          </button>
          <button
            class="flex w-9 items-center rounded-r border-y border-r border-gray-300 bg-white px-1.5 text-gray-400 hover:bg-gray-100"
            phx-click="next_month"
            phx-target={@target}
          >
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none" />
              <path d="M9 6l6 6l-6 6" />
            </svg>
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp events(assigns) do
    ~H"""
    <div class="flex flex-col gap-1 mt-2 text-xs">
      <div
        :for={event <- Enum.slice(@events, 0, 2)}
        class="flex flex-nowrap items-center hover:text-indigo-600 cursor-pointer"
      >
        <span class={[
          "w-2 h-2 rounded-full mr-2 shrink-0",
          Enum.random(["bg-green-400", "bg-pink-400", "bg-yellow-400"])
        ]}>
        </span>
        <span class="text-ellipsis truncate font-semibold">
          <%= event.title %>
        </span>
        <span class="shrink-0 ml-2 text-slate-600"><%= Calendar.strftime(event.on, "%-I%P") %></span>
      </div>
      <div
        :if={length(@events) > 2}
        class="px-3 border rounded-lg self-baseline mt-1 bg-gray-100 text-slate-800 font-medium"
      >
        <%= length(@events) - 2 %> more
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full my-4 rounded ring-1 ring-slate-200 overflow-hidden">
      <.cal_header target={@myself} date={@active_date} />
      <div class="h-full flex flex-col flex-auto bg-slate-200">
        <div class="grid grid-cols-7 gap-[1px]">
          <div
            :for={day <- List.first(@rows)}
            class="text-center p-2 border-y border-gray-300 bg-white text-sm font-semibold"
          >
            <%= Calendar.strftime(day, "%a") %>
          </div>
        </div>
        <div class="grid grid-cols-7 grid-flow-row gap-[1px] w-full">
          <%= for week <- @rows do %>
            <div
              :for={day <- week}
              class={
                "px-3 py-2 text-sm h-28 overflow-hidden #{if day_belongs_to_other_month?(day, @active_date), do: "bg-gray-50 text-slate-500", else: "bg-white text-slate-800"}"
              }
            >
              <time
                datetime={Date.to_string(day)}
                class={[
                  day == Date.utc_today() &&
                    "flex items-center justify-center font-bold bg-indigo-500 w-6 h-6 text-white rounded-full"
                ]}
              >
                <%= Calendar.strftime(day, "%-d") %>
              </time>
              <.events events={events_for_day(day, @events)} />
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
