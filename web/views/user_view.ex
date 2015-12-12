defmodule SampleApp.UserView do
  use SampleApp.Web, :view

  def gravator_for(email) do
    id = gravator_id(email)
    raw ~s(<img src="https://secure.gravatar.com/avatar/#{id}" />)
  end

  def gravator_id(email) do
    email
    |> :erlang.md5
    |> Base.encode16(case: :lower)
  end

  def paginate(conn, page_info) do
    total_page = page_info["total_page"]
    range = if total_page == 0 do
              []
            else
              1..total_page
            end
    current_page = page_info["current_page"]
    prev_link  = link_p(conn, current_page - 1, current_page <= 1, "<<")

    page_links = range
                 |> Enum.map( &(link_p(conn, &1, current_page == &1)) )

    next_link  = link_p(conn, current_page + 1, total_page <= current_page, ">>")

    content = [prev_link, page_links, next_link] |> Enum.join("")

    raw "<div class='paging-container'><ul class='pagination'>#{content}</ul></div>"
  end

  defp link_p(conn, page, disabled, text \\ nil) do
    text = text || to_string(page)

    content = if disabled do
      "<span>#{ text }</span>"
    else
      {:safe, link} = link text,
                        to: user_path(conn, :index, page: page),
                        class: "paging_link"
      Enum.join(link, "")
    end
    "<li class='#{disabled_klass(disabled)}'>#{ content }</li>"
  end

  defp disabled_klass(disabled) when disabled == true, do: "disabled"
  defp disabled_klass(_), do: ""
end
