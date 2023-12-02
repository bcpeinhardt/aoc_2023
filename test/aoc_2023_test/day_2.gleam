import gleeunit/should
import simplifile
import aoc_2023/day_2.{MarbleCount, marble_count_from_round, part_1, part_2}

pub fn part_1_test() {
  let assert Ok(txt) = simplifile.read("./input/day_2/example_part_1.txt")
  txt
  |> part_1
  |> should.equal(8)
}

pub fn part_2_test() {
  let assert Ok(txt) = simplifile.read("./input/day_2/example_part_2.txt")
  txt
  |> part_2
  |> should.equal(2286)
}

pub fn marble_count_from_round_test() {
  let round = "8 green, 6 blue, 20 red"
  round
  |> marble_count_from_round
  |> should.equal(MarbleCount(red: 20, blue: 6, green: 8))
}
