defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_users [
    "Daniele",
    "Mayk",
    "Giuliano",
    "Cleiton",
    "Jakeliny",
    "Joseph",
    "Diego",
    "Danilo",
    "Rafael",
    "Vinicius"
  ]

  @available_months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @available_years [2018, 2019, 2016, 2017, 2020]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.map(fn list -> make_values_as_numbers(list) end)
    |> Enum.reduce(report_acc(), fn line, report -> add_hours(line, report) end)

    # |> Enum.map(& &1)
  end

  defp make_values_as_numbers([user, work_time, day, month, year]) do
    {work_time, _} = Integer.parse(work_time)
    # day = Integer.parse(day)
    {month, _} = Integer.parse(month)
    {year, _} = Integer.parse(year)
    [user, work_time, day, month, year]
  end

  defp add_hours(
         [user, work_time, day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
    all_hours = Map.put(all_hours, user, all_hours[user] + work_time)

    per_month = hours_per_month[user]
    this_month = Enum.at(@available_months, month - 1)
    per_month = Map.put(per_month, this_month, per_month[this_month] + work_time)
    hours_per_month = Map.put(hours_per_month, user, per_month)

    per_year = hours_per_year[user]
    per_year = Map.put(per_year, year, per_year[year] + work_time)
    hours_per_year = Map.put(hours_per_year, user, per_year)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp report_acc do
    list_of_months = Enum.into(@available_months, %{}, &{&1, 0})
    list_of_years = Enum.into(@available_years, %{}, &{&1, 0})

    all_hours = Enum.into(@available_users, %{}, &{&1, 0})
    hours_per_month = Enum.into(@available_users, %{}, &{&1, list_of_months})
    hours_per_year = Enum.into(@available_users, %{}, &{&1, list_of_years})

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  # defp sum_hours_by_user()

  # def return_list_of_unique_users(filename) do
  #   filename
  #   |> Parser.parse_file()
  #   |> Enum.map(fn list -> get_head(list) end)
  #   |> Enum.uniq()
  # end

  # defp get_head([head | _tail]), do: head

  # def return_list_of_unique_months(filename) do
  #   filename
  #   |> Parser.parse_file()
  #   |> Enum.map(fn list -> get_month(list) end)
  #   |> Enum.uniq()
  # end

  # def return_list_of_unique_years(filename) do
  #   filename
  #   |> Parser.parse_file()
  #   |> Enum.map(fn list -> get_year(list) end)
  #   |> Enum.uniq()
  # end

  # defp get_year([_user, _work_time, _day, _month, year]), do: year
  # defp get_month([_user, _work_time, _day, month, _year]), do: month
end
