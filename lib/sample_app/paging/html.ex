defmodule SampleApp.Paging.HTML do
  import Phoenix.HTML
  import Phoenix.HTML.Link

  def paginate(conn, path_func3, page_info) do
    total_page = page_info.total_page
    range = if total_page == 0 do
              []
            else
              1..total_page
            end
    current_page = page_info.current_page

    prev_link  = link_p("<<", path_func3.(conn, :index, page: current_page - 1), current_page <= 1)

    page_links = range
                 |> Enum.map( fn (page) ->
                   link_p(page, path_func3.(conn, :index, page: page), current_page == page)
                 end)

    next_link  = link_p(">>", path_func3.(conn, :index, page: current_page + 1), total_page <= current_page)

    content = [prev_link, page_links, next_link] |> Enum.join("")

    raw "<div class='paging-container'><ul class='pagination'>#{content}</ul></div>"
  end

  defp link_p(text, url, disabled) do
    text = to_string(text)

    content = if disabled do
      "<span>#{ text }</span>"
    else
      {:safe, link} = link text,
                        to: url,
                        class: "paging_link"
      Enum.join(link, "")
    end
    "<li class='#{disabled_klass(disabled)}'>#{ content }</li>"
  end

  defp disabled_klass(disabled) when disabled == true, do: "disabled"
  defp disabled_klass(_), do: ""
end
