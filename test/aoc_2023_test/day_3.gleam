import gleeunit/should
import simplifile
import aoc_2023/day_3.{part_1, part_2}

pub fn part_1_test() {
  let assert Ok(txt) = simplifile.read("./input/day_3/example_part_1.txt")
  txt
  |> part_1
  |> should.equal(4361)
}

pub fn part_2_test() {
  let assert Ok(txt) = simplifile.read("./input/day_3/example_part_1.txt")
  txt
  |> part_2
  |> should.equal(467_835)
}
