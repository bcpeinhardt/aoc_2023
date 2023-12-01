import gleeunit/should
import simplifile
import aoc_2023/day_1.{part_1, part_2}

pub fn part_1_test() {
  let assert Ok(txt) = simplifile.read("./input/day_1/example_part_1.txt")
  txt
  |> part_1
  |> should.equal(142)
}

pub fn part_2_test() {
  let assert Ok(txt) = simplifile.read("./input/day_1/example_part_2.txt")
  txt
  |> part_2
  |> should.equal(281)
}
