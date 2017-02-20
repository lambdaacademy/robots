use Mix.Releases.Config,
  default_environment: :prod

environment :prod do
  set include_erts: true
  set include_src: true
  set cookie: :"=Y@RGX5JCk1,En8hFCeeY/8XaC&}D4Nl7_tGC;^?=aPQf]T[B/ms1<v~9c&]KL7:"
end

release :music_pi do
  set version: "0.1.0"
  set applications: [
    bot: :permanent,
    music_pi: :permanent,
    p1_utils: :permanent,
    ssl: :permanent
  ]
end

release :photo_pi do
  set version: "0.1.0"
  set applications: [
    bot: :permanent,
    photo_pi: :permanent,
    p1_utils: :permanent,
    oauther: :permanent,
    poison: :permanent
  ]
end
