# 🏋️ Career Gym

> A personal training system for becoming a stronger, more valuable, and better-paid Backend Engineer.

Career Gym is a structured system for continuously developing technical skills, practicing real engineering problems, building proof of work, preparing for interviews, and improving career opportunities.

The goal is simple:

**Don't just study. Train. Practice. Prove. Communicate. Apply. Improve.**

---

## 🎯 Career Goal

Build the capabilities and evidence required to move toward higher-level and higher-paying backend engineering opportunities, with a focus on:

* Senior Backend Engineering
* Staff-level engineering
* International remote opportunities
* High-performance Rails/backend systems
* System design and distributed systems

---

## 🧭 The Career Gym Loop

```text
             ┌──────────────┐
             │   CAREER     │
             │    GOAL      │
             └──────┬───────┘
                    ↓
             ┌──────────────┐
             │   SKILL GAP  │
             └──────┬───────┘
                    ↓
             ┌──────────────┐
             │   TRAINING   │
             └──────┬───────┘
                    ↓
             ┌──────────────┐
             │   PRACTICE   │
             └──────┬───────┘
                    ↓
             ┌──────────────┐
             │    PROOF     │
             └──────┬───────┘
                    ↓
             ┌──────────────┐
             │  INTERVIEW   │
             └──────┬───────┘
                    ↓
             ┌──────────────┐
             │  JOB MARKET  │
             └──────┬───────┘
                    ↓
             ┌──────────────┐
             │   FEEDBACK   │
             └──────┬───────┘
                    │
                    └──────────→ New Training
```

---

# 🏋️ Training Areas

## 1. Backend Architecture

Develop the ability to design and reason about production systems.

* System Design
* Distributed Systems
* Scalability
* Reliability
* Consistency
* Idempotency
* Caching
* Messaging
* Background jobs
* Concurrency

---

## 2. Data & Performance

Become exceptionally strong at understanding what happens inside backend systems.

* PostgreSQL
* Advanced SQL
* Query planning
* Indexes
* Joins
* Transactions
* Locking
* N+1 queries
* Database performance
* Benchmarking
* Load testing
* Caching

---

## 3. Ruby & Rails

Go beyond framework usage and understand how Rails applications behave in production.

* Ruby internals
* Rails internals
* Active Record
* Active Job
* Background processing
* API design
* Testing
* Performance
* Concurrency
* Application architecture
* Production debugging

---

## 4. Cloud & Production

Develop production engineering skills.

* AWS
* Docker
* CI/CD
* Deployment
* Infrastructure
* Observability
* Metrics
* Logs
* Tracing
* Grafana
* Incident analysis
* Reliability

---

## 5. Modern Backend & AI

Explore technologies that expand the backend engineering skill set.

* LLM fundamentals
* Embeddings
* RAG
* Vector databases
* AI applications
* AI agents
* AI-assisted development

This track supports the core backend journey rather than replacing it.

---

# 🧪 Engineering Lab

Career Gym emphasizes **learning by experimentation**.

Instead of simply reading about a technology, create experiments that answer engineering questions.

Example:

```text
Question:
Why is this Rails endpoint slow?

        ↓

Hypothesis:
The endpoint is suffering from N+1 queries.

        ↓

Experiment:
Compare lazy loading vs eager loading.

        ↓

Measure:
- SQL queries
- execution time
- allocations
- response time

        ↓

Explain:
Document why the optimization works.

        ↓

Proof:
Publish the experiment on GitHub.
```

Typical experiments include:

* N+1 queries
* PostgreSQL indexes
* `EXPLAIN ANALYZE`
* Query optimization
* Pagination strategies
* Caching
* Background jobs
* Concurrency
* Database locking
* API performance
* Load testing
* Observability
* Distributed systems

---

# 💼 Interview Gym

Technical knowledge needs to become **communicable knowledge**.

Career Gym includes dedicated interview training for:

### Coding

* Ruby
* Algorithms
* Data structures
* Problem solving

### SQL

* Joins
* Aggregations
* Window functions
* Query optimization
* Database design

### System Design

Practice answering questions such as:

* How would you design this system?
* What happens when traffic increases 100×?
* Where is the bottleneck?
* How would you make it reliable?
* How would you handle failures?
* How would you make the operation idempotent?
* What should be synchronous vs asynchronous?

### Behavioral

Build a library of real engineering stories covering:

* Difficult technical problems
* Performance improvements
* Production incidents
* Architecture decisions
* Technical disagreements
* Failures and lessons
* Leadership
* Mentoring
* Ownership

---

# 🏆 Proof of Work

The objective isn't to accumulate courses.

The objective is to create **evidence of engineering ability**.

Proof can include:

* GitHub repositories
* Engineering experiments
* Benchmarks
* System design documents
* Technical articles
* Open-source contributions
* Production case studies
* Architecture diagrams
* Interview solutions

A useful rule:

> **Every important skill should eventually produce something you can show.**

---

# 🚀 Job Hunt

Career Gym also tracks the transition from preparation to actual opportunities.

```text
Target Companies
       ↓
Applications
       ↓
Recruiters
       ↓
Interviews
       ↓
Technical Interviews
       ↓
Offers
       ↓
Negotiation
```

Track:

* Company
* Role
* Location
* Compensation
* Application date
* Stage
* Interview feedback
* Rejection reason
* Lessons learned
* Next action

The job market itself becomes a source of feedback.

---

# 📊 Progress

Career progress is measured by **capability**, not study hours.

Example:

| Skill               | Current | Target |
| ------------------- | ------: | -----: |
| Ruby / Rails        |       9 |      9 |
| PostgreSQL          |       6 |      8 |
| System Design       |       2 |      8 |
| AWS                 |       2 |      7 |
| Observability       |       4 |      7 |
| Distributed Systems |       3 |      8 |
| AI Engineering      |       2 |      6 |
| English             |       8 |      9 |

The numbers are subjective. Their purpose is to identify where training should be concentrated.

---

# 🔁 Training Session

Every training session should follow a simple structure:

```text
SKILL
  ↓
QUESTION
  ↓
LEARN
  ↓
EXERCISE
  ↓
MEASURE
  ↓
EXPLAIN
  ↓
PROVE
```

Example:

```text
Skill:
PostgreSQL Performance

Question:
When does a composite index improve a query?

Learn:
Indexes + query planner

Exercise:
Create a database with 1M records.

Measure:
EXPLAIN ANALYZE

Compare:
No index
Single-column index
Composite index

Explain:
Write the findings.

Prove:
Commit the experiment to GitHub.
```

---

# 🗂️ Repository Structure

```text
career-gym/
│
├── README.md
│
├── career/
│   ├── goals/
│   ├── strategy/
│   ├── target-roles/
│   └── target-companies/
│
├── skills/
│   ├── ruby-rails/
│   ├── postgresql/
│   ├── system-design/
│   ├── aws/
│   ├── observability/
│   ├── distributed-systems/
│   └── ai/
│
├── labs/
│   ├── performance/
│   ├── database/
│   ├── concurrency/
│   ├── caching/
│   ├── background-jobs/
│   ├── observability/
│   └── system-design/
│
├── interviews/
│   ├── coding/
│   ├── sql/
│   ├── system-design/
│   ├── rails/
│   ├── behavioral/
│   └── english/
│
├── proof-of-work/
│   ├── articles/
│   ├── architecture/
│   ├── benchmarks/
│   └── case-studies/
│
└── job-hunt/
    ├── companies/
    ├── applications/
    ├── interviews/
    └── lessons/
```

---

# 📅 Weekly Training

A typical week:

| Day       | Focus                   |
| --------- | ----------------------- |
| Monday    | 📚 Learn                |
| Tuesday   | 🧠 Deep technical study |
| Wednesday | 🧪 Engineering Lab      |
| Thursday  | 🎤 Interview Practice   |
| Friday    | 🏆 Proof of Work        |
| Saturday  | 💼 Job Market           |
| Sunday    | 📊 Weekly Review        |

The schedule is flexible.

The important thing is maintaining the loop:

**Learn → Practice → Prove → Communicate → Apply**

---

# 🥇 Principles

### 1. Optimize for capability, not consumption

Finishing a course isn't the goal.

Being able to solve the problem is.

### 2. Learn through experiments

Whenever possible, reproduce the problem yourself.

### 3. Measure

Use data whenever possible:

* latency
* throughput
* memory
* allocations
* query count
* database execution time
* error rate

### 4. Explain what you learn

If you cannot explain it clearly, you probably don't understand it deeply enough.

### 5. Build public proof

Turn learning into GitHub projects, experiments, articles, and system designs.

### 6. Practice interviews before you need them

Interview preparation is continuous training, not an emergency activity.

### 7. Use the job market as feedback

Rejections and interview feedback identify skill gaps.

### 8. Prefer depth over technology collecting

Master important engineering concepts before jumping to another framework or tool.

---

# 🎯 Definition of Success

Career Gym is successful when it produces measurable career improvements:

```text
Better Engineering Skills
        +
Stronger Technical Communication
        +
Visible Proof of Work
        +
Better Interview Performance
        +
Better Job Opportunities
        +
Higher Compensation
```

Ultimately:

> **Career Gym is not about becoming better at studying.**
>
> **It is about becoming harder to replace and easier to hire.**
