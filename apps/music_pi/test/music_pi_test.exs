defmodule MusicPiTest do
  use ExUnit.Case, async: false
  import Mock

  def file_mock do
    [ls!: fn(_) -> ["foo", "bar"] end]
  end

  def porcelain_mock do
    [spawn_shell: fn(_, _) -> %Porcelain.Process{pid: :c.pid(0, 250, 0)} end]
  end

  def porcelain_process_mock do
    [send_input: fn(_, _) -> true end,
     stop: fn(_) -> true end]
  end

  test_with_mock "Player returns correct list of actions",
    File, [], file_mock() do
      assert MusicPi.actions ==
              [{"0", "Stop music"}, {"1", "foo"}, {"2", "bar"}]
  end

  test "Player plays mocked song without errors" do
    with_mocks([{File, [], file_mock()},
                {Porcelain, [], porcelain_mock()},
                {Porcelain.Process, [], porcelain_process_mock()}]) do
      assert {:ok, _} = MusicPi.run_action("1")
    end
  end

  test "Player stops played song without errors" do
    with_mocks([{File, [], file_mock()},
                {Porcelain, [], porcelain_mock()},
                {Porcelain.Process, [], porcelain_process_mock()}]) do
      assert {:ok, _} = MusicPi.run_action("1")
      assert {:ok, _} = MusicPi.run_action("0")
    end
  end

  test "Player allows to stop multiple times song without errors" do
    with_mocks([{File, [], file_mock()},
                {Porcelain, [], porcelain_mock()},
                {Porcelain.Process, [], porcelain_process_mock()}]) do
      assert {:ok, _} = MusicPi.run_action("1")
      assert {:ok, _} = MusicPi.run_action("2")
      assert {:ok, _} = MusicPi.run_action("0")
      assert {:ok, _} = MusicPi.run_action("1")
      assert {:ok, _} = MusicPi.run_action("0") 
    end  
  end
end
