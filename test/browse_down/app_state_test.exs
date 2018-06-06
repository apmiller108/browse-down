defmodule BrowseDown.AppStateTest do
  use ExUnit.Case, async: true

  setup do
    app_state = start_supervised(BrowseDown.AppState)

    File.mkdir!("temp/")
    File.write!("temp/test1.md", "")
    File.write!("temp/test2.md", "")

    on_exit fn ->
      File.rm("temp/test1.md")
      File.rm("temp/test2.md")
      File.rmdir("temp/")
    end

    %{app_state: app_state, temp_dir: Path.expand("temp/")}
  end

  test "initial state" do
    assert BrowseDown.AppState.index == %{temp_dirs: []}
  end

  test "cleanup", %{app_state: _, temp_dir: dir} do
    BrowseDown.AppState.put_dir(dir)

    BrowseDown.AppState.cleanup

    assert File.exists?("temp/test1.md") == false
    assert File.exists?("temp/test2.md") == false
    assert File.exists?(dir) == false
  end

  test "adding directories", %{app_state: _, temp_dir: dir}do
    BrowseDown.AppState.put_dir(dir)

    %{temp_dirs: [first | rest]} = BrowseDown.AppState.index
    assert rest == []
    assert List.last(String.split(first, "/")) == "temp"

    BrowseDown.AppState.cleanup
  end
end
