# Mbrcode

**Mbrcode** is a lightweight, deterministic, and clean **membership code generator** for Ruby applications.

It produces stable, structured IDs using the format:

PREFIX + SHARD + "-" + DIGITS

Where:

- **PREFIX** → normalized to exactly 4 characters
- **SHARD** → numeric grouping/version number
- **DIGITS** → auto-incrementing sequence
- **Raw length before dashes** = **EXACTLY 16 characters**

Example output:

MBR1-0000-0000-000

Mbrcode is ideal for membership systems, gyms, schools, apps, organizations, ERPs, identity platforms, and anything requiring clean, compact, and consistent codes.

---

## ✨ Features

- 🔒 Thread-safe incremental counter
- 🧩 Smart prefix normalization rules
- 📏 Always 16 raw characters before dash grouping
- 🔣 Groups digits into 4-4-4 format when possible
- ⚙️ Configurable prefix and shard
- 💎 Zero external dependencies
- 🚀 Fast, simple, production-ready

---

## 📦 Installation

Add to your Gemfile:

```ruby
gem "mbrcode"
```

Install:

```bash
bundle install
```

Or install manually:

```bash
gem install mbrcode
```

---

## 🚀 Usage

### Default generation

```ruby
Mbrcode.generate
# => "MBR1-0000-0000-000"
```

### Custom prefix

```ruby
Mbrcode.generate(prefix: "user")
# => "USER1-0000-0000-000"
```

### Multi-word prefix → initials

```ruby
Mbrcode.generate(prefix: "karate membership")
# => "KM00-0000-0000-000"
```

### Prefix shorter than 4 chars → padded

```ruby
Mbrcode.generate(prefix: "ab")
# => "AB00-0000-0000-000"
```

### Long prefix → first 4 characters

```ruby
Mbrcode.generate(prefix: "customer")
# => "CUST1-0000-0000-000"
```

### Custom shard

```ruby
Mbrcode.generate(prefix: "mbr", shard: 2)
# => "MBR2-0000-0000-000"
```

---

## 🧠 Prefix Normalization Rules

| Input Prefix        | Output Prefix | Rule Applied           |
|---------------------|---------------|-------------------------|
| "m"                 | "M000"        | padded to 4 characters |
| "ab"                | "AB00"        | padded to 4 characters |
| "karate membership" | "KM00"        | initials + padded      |
| "ruby on rails"     | "ROR0"        | initials + padded      |
| "customer"          | "CUST"        | first 4 characters     |
| "USER"              | "USER"        | unchanged (4 chars)    |

---

## 🔢 16-Character Enforcement

Before grouping and adding dashes, the ID ALWAYS equals:

PREFIX(4) + SHARD(N) + DIGITS(M) = 16 characters

If the shard leaves no space for digits:

```ruby
Mbrcode.generate(prefix: "abcd", shard: 999999999)
# => raises "Shard too long"
```

This ensures consistent, predictable, compact membership IDs.

---

## 🧪 Testing

Run RSpec tests:

```bash
bundle exec rspec
```

All tests should pass.

---

## 🛠 Development

Clone the repository:

```bash
git clone https://github.com/delacruzjames/mbrcode.git
cd mbrcode
```

Install dependencies:

```bash
bundle install
```

Run tests:

```bash
bundle exec rspec
```

---

## 🤝 Contributing

Pull requests are welcome!  
Please include tests for new features or bug fixes.

---

## 📜 License

Released under the **MIT License**.

---

## 👤 Author

**Sensei James Dela Cruz**  
Ruby Developer • API Architect • Karate Instructor

📧 Email: `delacruzjamesmartin@gmail.com`  
🐙 GitHub: `@delacruzjames`
