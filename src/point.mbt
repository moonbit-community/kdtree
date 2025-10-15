///|
pub trait Point {
  to_fixedarray(Self) -> FixedArray[Int]
}

///|
pub impl Point for (Int, Int) with to_fixedarray(self) {
  return [self.0, self.1]
}

///|
pub impl Point for (Int, Int, Int) with to_fixedarray(self) {
  return [self.0, self.1, self.2]
}

///|
pub impl Point for (Int, Int, Int, Int) with to_fixedarray(self) {
  return [self.0, self.1, self.2, self.3]
}

///|
pub impl Point for (Int, Int, Int, Int, Int) with to_fixedarray(self) {
  return [self.0, self.1, self.2, self.3, self.4]
}

///|
pub impl Point for (Int, Int, Int, Int, Int, Int) with to_fixedarray(self) {
  return [self.0, self.1, self.2, self.3, self.4, self.5]
}

///|
pub impl Point for (Int, Int, Int, Int, Int, Int, Int) with to_fixedarray(self) {
  return [self.0, self.1, self.2, self.3, self.4, self.5, self.6]
}

///|
pub impl Point for (Int, Int, Int, Int, Int, Int, Int, Int) with to_fixedarray(
  self,
) {
  return [self.0, self.1, self.2, self.3, self.4, self.5, self.6, self.7]
}

///|
pub impl Point for (Int, Int, Int, Int, Int, Int, Int, Int, Int) with to_fixedarray(
  self,
) {
  return [
    self.0,
    self.1,
    self.2,
    self.3,
    self.4,
    self.5,
    self.6,
    self.7,
    self.8,
  ]
}

///|
pub impl Point for (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) with to_fixedarray(
  self,
) {
  return [
    self.0,
    self.1,
    self.2,
    self.3,
    self.4,
    self.5,
    self.6,
    self.7,
    self.8,
    self.9,
  ]
}

///|
pub impl Point for (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) with to_fixedarray(
  self,
) {
  return [
    self.0,
    self.1,
    self.2,
    self.3,
    self.4,
    self.5,
    self.6,
    self.7,
    self.8,
    self.9,
    self.10,
  ]
}

///|
pub impl Point for FixedArray[Int] with to_fixedarray(self) {
  return self
}
