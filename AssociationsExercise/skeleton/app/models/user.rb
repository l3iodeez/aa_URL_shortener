class User < ActiveRecord::Base
  has_many(
      :enrollments,
      class_name: "Enrollment",
      foreign_key: :student_id,
      primary_key: :id
  )
  has_many(
    :enrolled_courses,
    through: :enrollments,
    source:  :course
    )
  has_many(
    :instructors,
    through: :enrolled_courses,
    source:  :enrollments
  )
  has_many(
    :taught_courses,
    class_name: 'Course',
    foreign_key: :instructor_id,
    primary_key: :id
  )
  has_many(
    :students,
    through: :taught_courses,
    source:  :enrollments
  )
end
