defmodule LiveAdmin.Components.Container.Form.ArrayInput do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  import LiveAdmin, only: [trans: 1]

  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :values, [])}
  end

  @impl true
  def update(assigns = %{form: form, field: field}, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:values, input_value(form, field) || [])

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns = %{disabled: true}) do
    ~H"""
    <div>
      <span class="resource__action--disabled">
        <ul>
          <%= for item <- @values do %>
            <li><%= item %></li>
          <% end %>
        </ul>
      </span>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="field__array--group">
      <%= for {item, idx} <- Enum.with_index(@values) do %>
        <div>
          <a
            class="button__remove"
            phx-click={
              JS.push("validate",
                value: %{field: @field, value: List.delete_at(@values, idx)},
                target: @form_ref,
                page_loading: true
              )
            }
          />
          <%= text_input(:form, :array,
            id: input_id(@form, @field) <> "_#{idx}",
            name: input_name(@form, @field) <> "[]",
            value: item
          ) %>
        </div>
      <% end %>

      <div class="form__actions">
        <a href="#" phx-click="add" phx-target={@myself} class="resource__action--btn">
          <%= trans("New") %>
        </a>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("add", _params, socket) do
    socket = assign(socket, values: socket.assigns.values ++ [""])

    {:noreply, socket}
  end
end
