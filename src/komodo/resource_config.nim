type
  ResourceConfig* = object
    directory*: string


func newResourceConfig*(
  directory: string;
): ResourceConfig =
  ResourceConfig(
    directory: directory,
  )

