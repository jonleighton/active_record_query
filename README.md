# AR Query Plugin #

Imaginatively named, I know.

This is a proof-of-concept I want to be considered for inclusion in
Rails 4.

## Synopsis ##

``` ruby
Person.where { |q| q.name == 'Jon' && q.age == 22 }
# => SELECT * FROM people WHERE people.name = 'Jon' AND people.age = 22

Person.any { |q| q.name == 'Jon' || q.age == 22 }
# => SELECT * FROM people WHERE people.name = 'Jon' OR people.age = 22

Person.joins(:projects).where { |q| q.projects.name == 'Rails' }
# => SELECT * FROM people INNER JOIN projects WHERE projecs.name = 'Rails'

Person.any { |q| q.name = 'Jon' || q.and { q.age >= 10 && q.age < 30 } }
# => SELECT * FROM people WHERE people.name = 'Jon' OR (people.age >= 10 AND people.age < 30)
```

## Why? ##

*   Makes people (who use it) less vulnerable to accidentally introducing
    SQL injection points

*   If we have the AST, we can draw inferences from it in Active Record.
    For example, in Rails 4,

    ``` ruby
    Post.includes(:comments).where('comments.created_at > x')
    ```

    will no longer `JOIN` the `comments` table. You have to do:

    ``` ruby
    Post.includes(:comments).where('comments.created_at > x').references(:comments)
    ```

    With the AST available to us, we can automatically infer that
    `comments` is referenced.

## Prior art ##

* https://github.com/ernie/squeel
* http://defunkt.io/ambition/

## Design goals ##

*   Don't use `instance_eval`. Here be dragons.

*   Make the syntax as easy on the eyes as possible.

    `&&` and `||`
    cannot be redefined as methods (more about that below), but `&` and
    `|` can be. However, they bind tighter than comparison operators,
    resulting in lots of unpleasant parentheses:

    ``` ruby
    Person.where { |q| (q.name == 'Jon') & (q.age == 22) }
    ```

    `&` and `|` are also commonly used for set operations, which have an
    existing meaning in SQL.

## Implementation ##

The `q` object is *mutable*.

Writing,

``` ruby
Post.where { |q| q.name == 'Jon' && q.age == 22 }
```

has the identical effect as writing,

``` ruby
Post.where do |q|
  q.name == 'Jon'
  q.age == 22
end
```

The `==` method return `true` to prevent the `&&` operator from
short-circuiting. Using `&&` is purely syntactical sugar.

Note that,

``` ruby
Post.where { |q| q.name == 'Jon' || q.age == 22 }
```

*would* short-circuit.

So whilst this wouldn't throw an error, it at
least would result in something that the user would (hopefully) notice
is wrong quite quickly (because `age` would be missing from the query
entirely).

This 'hack' is definitely the worst thing about the idea, but I think
that with adaquate documentation it wouldn't pose too much problem, and
it reads quite naturally.

## Supported operators ##

``` ruby
q.name == 'Jon'
q.name != 'Jon'
q.name =~ 'J%'
q.name !~ 'J%'
q.name > 22
q.name < 22
q.name >= 22
q.name <= 22
q.name.in ['Jon', 'Emily']
q.name.not_in ['Jon', 'Emily']
```

## Possible alternative syntaxes ##

### Option 1 (Squeel syntax) ###

``` ruby
Person.where { |q| (q.name == 'Jon') | (q.age == 22) }
```

* Doesn't require the `q.and { ... }` thing for `AND`-within-`OR` or
  `OR`-within-`AND`
* Possibly confusing use of set operators
* Lots of parentheses

### Option 2 ###

``` ruby
Person.where { |q| q.name == 'Jon'; q.age == 22 }
```

* This works already, it's a question of what we advocate / document.

### Option 3 ###

``` ruby
Person.any { |q| q[:name] == 'Jon' || q.projects[:name] == 'Rails' }
```

* Draws a clearer distinction between table and column names
* A bit more noisy
