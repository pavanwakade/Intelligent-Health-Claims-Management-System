---
name: frontend-skill
description: "Unified frontend skill covering design, architecture, React, Next.js, routing, state, styling, performance, accessibility, security, validation, mobile scaffolding, and specialized UI patterns."
risk: medium
source: local-consolidation
date_added: "2026-04-15"
---

# Frontend Skill

Single consolidated frontend skill built from the guidance already present in `skills/frontend/` and its subdirectories.

Use this skill when the task involves frontend implementation, frontend design, frontend reviews, component scaffolding, routing, state management, accessibility, visual quality, performance, or frontend security.

Do not use this skill when the task is purely backend, infrastructure-only, or unrelated to web or mobile UI.

## Core Mandate

Build production-grade interfaces that are:

- technically correct
- visually intentional
- accessible by default
- responsive across breakpoints
- performant under real usage
- secure against common frontend risks
- maintainable through clear structure and types

Avoid generic output. Do not ship placeholder-quality UI, weak loading states, inaccessible interactions, or untyped data flows.

## Working Order

When executing frontend work, follow this order:

1. Understand the product goal, users, device targets, and constraints.
2. Choose an architecture: feature boundaries, route boundaries, rendering model, and state strategy.
3. Define the visual direction before writing markup or components.
4. Implement responsive, accessible UI with clear state handling.
5. Validate performance, visual quality, edge states, and security.

## Design Direction

You are a frontend designer-engineer, not a layout generator.

Every output must satisfy all of the following:

1. Intentional aesthetic direction.
2. Working code, not mockup thinking.
3. At least one memorable visual decision.
4. Cohesive restraint.

Rules:

- Avoid default, safe, interchangeable layouts.
- Avoid overused fonts and purple-on-white gradient cliches.
- Pick a named aesthetic direction before building.
- Use typography, color, spacing, motion, and background treatments as a system.
- Keep design distinctive without hurting performance or usability.

### Design Feasibility Check

Before large UI work, evaluate:

- aesthetic impact
- context fit
- implementation feasibility
- performance safety
- consistency risk

If the concept is visually strong but hard to maintain, reduce flourish and keep the core idea.

## Architecture

### Feature-Based Structure

Prefer feature-based organization for domain logic:

```text
src/
  features/
    posts/
      api/
      components/
      hooks/
      helpers/
      types/
      index.ts
  components/
    SuspenseLoader/
    ErrorBoundary/
  routes/
    posts/
      index.tsx
```

Use `features/` for domain-specific logic, APIs, hooks, and types.

Use `components/` only for truly reusable primitives or shared UI patterns.

### Component Responsibility

- Keep one responsibility per component.
- Split large components early.
- Prefer composition over inheritance.
- Keep props down and events up.
- Move repeated logic into hooks.

## React Patterns

Prefer modern React patterns:

- functional components
- small focused components
- custom hooks for repeated logic
- Suspense boundaries where supported
- targeted optimization instead of blanket memoization

### Component Pattern

```tsx
interface UserCardProps {
  userId: string;
  onEdit?: () => void;
}

export const UserCard: React.FC<UserCardProps> = ({ userId, onEdit }) => {
  return <section>{userId}</section>;
};

export default UserCard;
```

Guidelines:

- define props explicitly
- use `import type` for type-only imports
- keep exports predictable
- document non-obvious props

### React 19 / Modern React

When relevant, prefer modern patterns such as:

- `useActionState`
- `useOptimistic`
- `use`
- transitions for non-urgent updates
- compiler-friendly pure components

Do not add `useMemo` or `useCallback` by reflex. Add them when there is a concrete render or computation reason.

## Next.js and Rendering Strategy

When using Next.js:

- prefer App Router patterns
- use Server Components for data-heavy, non-interactive work
- keep Client Components focused on interactivity
- split code at route and heavy component boundaries
- parallelize independent server fetches

Rendering model guidance:

- Server Component: static or data-first UI
- Client Component: stateful or interactive UI
- Presentational component: props-only rendering
- Container component: orchestration and state ownership

## Data Fetching

For modern React apps, prefer server state tools such as TanStack Query for client-side data fetching and caching.

### Preferred Pattern

For new client-side data flows, prefer Suspense-compatible fetching where the app supports it.

```tsx
const { data } = useSuspenseQuery({
  queryKey: ['post', postId],
  queryFn: () => postApi.getPost(postId),
});
```

Rules:

- centralize API calls in feature API modules
- keep query keys consistent
- check cache before redundant network work when useful
- invalidate or update cache after mutations
- do not scatter raw fetch logic across UI components

### Mutation Rules

- disable triggers during in-flight mutations
- show success and error feedback
- rollback optimistic updates when needed
- never swallow errors silently

## Loading, Empty, and Error States

Every async UI must define:

- loading state
- empty state
- error state
- success state

Rules:

- Only show blocking loading indicators when there is no usable data.
- Prefer skeletons for known layouts and spinners for small inline actions.
- Every collection needs an explicit empty state.
- Users must always see failure feedback.

Do not leave loading or error handling implicit.

## Routing

Use clear route boundaries and lazy-load heavy route content.

For TanStack Router:

```text
routes/
  __root.tsx
  index.tsx
  posts/
    index.tsx
    create/
      index.tsx
    $postId.tsx
```

Guidelines:

- let folders express route structure
- lazy-load large route modules
- keep route loaders focused
- use type-safe params and navigation APIs

## State Management

Choose the smallest tool that matches the problem.

### Selection Guide

- local UI state: `useState`, `useReducer`
- subtree state: context
- server state: TanStack Query or SWR
- lightweight global client state: Zustand
- complex enterprise workflows: Redux Toolkit
- fine-grained atomic state: Jotai

Rules:

- colocate state near its usage
- avoid globalizing local state
- do not duplicate server state in global stores
- prefer selectors to reduce re-renders
- avoid storing easily derived state

## Styling Systems

Work within the project’s styling approach instead of mixing several at once.

Supported patterns covered by this skill:

- MUI `sx`
- Tailwind CSS
- Radix UI primitive composition
- CSS variables / design tokens
- CSS modules or scoped styles when the codebase already uses them

### MUI Guidance

- prefer `sx` over legacy styling APIs
- use responsive objects for breakpoint-aware values
- keep smaller style objects inline
- move large style maps into dedicated style files

### Tailwind Guidance

- use design tokens and semantic utility composition
- keep variant systems consistent
- use container queries and responsive patterns when appropriate
- avoid utility soup by extracting shared primitives

### Radix Guidance

Use Radix when you need accessible, headless primitives with full styling control.

Rules:

- never remove accessibility primitives such as titles, descriptions, or focus management
- use `asChild` to avoid invalid nested interactive elements
- choose controlled mode only when external state sync is needed
- compose primitives rather than overriding their core behavior

## Accessibility

Accessibility is mandatory.

Every interactive UI must have:

- keyboard access
- visible focus states
- semantic structure
- sufficient color contrast
- clear labels and descriptions
- proper loading, disabled, and error signaling

For dialogs, menus, tabs, and popovers:

- trap and restore focus correctly
- preserve Escape and keyboard behavior
- ensure screen reader context is complete

## Performance

Optimize with evidence, not superstition.

### Priority Order

1. Confirm there is a real problem.
2. Profile the bottleneck.
3. Apply the smallest targeted fix.
4. Re-measure.

### Common Fixes

- lazy-load heavy UI
- virtualize large lists
- parallelize independent fetches
- memoize expensive calculations
- stabilize callbacks passed into memoized children
- batch DOM reads and writes
- defer third-party code
- preload or prefetch strategically
- clean up timers, listeners, and subscriptions

Do not optimize everything. Optimize what is slow.

## Visual Validation

Assume frontend work is incomplete until validated.

Review visually for:

- layout correctness
- responsive behavior
- loading and error states
- design token consistency
- focus indicators
- dark/light theme consistency when applicable
- motion quality
- text scaling and readability

Use a skeptical validation stance:

- describe what is visibly true
- compare against the intended result
- look for evidence of failure, not just change

## Security

Frontend code must be safe against common injection and misuse patterns.

### XSS Rules

- never put unsanitized user data into `innerHTML`, `outerHTML`, or similar APIs
- avoid `document.write`
- treat `dangerouslySetInnerHTML` as high-risk
- sanitize HTML with a trusted sanitizer such as DOMPurify when raw HTML is required
- validate URLs before assigning them to navigation or link targets
- block `javascript:` and unsafe protocols

Framework notes:

- React: sanitize before any unsafe HTML render
- Vue: avoid `v-html` unless sanitized
- Angular: do not bypass built-in sanitization

## TypeScript Standards

Strict typing is part of the architecture.

Rules:

- no implicit `any`
- avoid explicit `any`
- use `unknown` when the type is genuinely unknown
- narrow with type guards
- add explicit return types where clarity matters
- prefer typed API responses
- use discriminated unions for UI states when useful

## Common UI Patterns

This skill includes standard patterns for:

- authentication-aware UI via shared auth hooks
- forms with React Hook Form and Zod
- dialogs and confirmation flows
- tables and grids
- search and filtering
- optimistic updates
- toasts or snackbars for feedback

Principles:

- forms must surface validation clearly
- submit buttons must disable during submission
- destructive actions need confirmation
- retries should be offered where appropriate

## Mobile and Component Scaffolding

When scaffolding components for web or React Native:

- generate a typed props interface
- include accessibility behavior from the start
- include tests for render and interaction
- include a consistent export structure
- include styles aligned with the project stack
- add Storybook stories when the repo uses Storybook

For mobile-aware work:

- validate touch targets
- verify safe-area and viewport behavior
- keep navigation and gestures predictable
- respect reduced motion and accessibility settings

## Specialized Frontend Areas

This unified skill also covers the specialized areas already present in the frontend skill set:

- 3D web experiences with Spline, Three.js, and React Three Fiber
- animation systems and motion patterns
- HTML-only presentation and slide experiences
- React Flow architecture and node implementation
- modernization and migration from legacy React patterns
- design-system construction with Tailwind or Radix
- advanced UI/UX reasoning and design system choice

### 3D Guidance

Use 3D only when it improves understanding, immersion, or product storytelling.

Rules:

- prefer the simplest stack that achieves the goal
- preserve usability and accessibility
- keep render cost under control
- do not turn navigation or critical workflows into novelty interactions

## Code Review Standard

When reviewing frontend changes, prioritize:

1. regressions
2. accessibility gaps
3. broken state handling
4. performance risks
5. security issues
6. missing tests

Do not focus on style nitpicks before user-visible correctness.

## Anti-Patterns

Avoid all of the following:

- giant components with mixed concerns
- prop drilling across deep trees when context or composition is cleaner
- premature global state
- loading spinners over already usable data
- silent failures
- inaccessible custom controls
- untyped API responses
- unsafe HTML rendering
- route files doing too much business logic
- random visual decoration without a design thesis
- performance changes without profiling

## Execution Checklist

Before considering a frontend task complete, verify:

- architecture fits the problem
- visual direction is intentional
- responsive behavior works
- async states are complete
- accessibility basics are present
- types are sound
- mutations provide feedback
- performance risks are addressed
- no obvious XSS or unsafe DOM usage exists
- visual QA has been performed

## Output Expectation

When using this skill, produce:

- clear implementation decisions
- production-ready code
- explicit handling of states and edge cases
- concise reasoning for tradeoffs
- validation notes for performance, accessibility, and visual quality

## Verified Source Coverage

This merged skill was verified against the current `skills/frontend` tree, including:

- top-level frontend markdown guides
- `react/` skill directories and nested resources
- `tailwind-design-system/`
- `tailwind-patterns/`
- `ui-skills/`
- `ui-ux-designer/`
- `ui-ux-pro-max/`

Supporting assets such as CSV, JSON, template, CSS, and example files were also checked where they contributed stack references, tool references, or implementation context.

## Repository and Reference Map

The following repositories, libraries, and primary references are already represented across the frontend skill files and are part of this unified skill's source context.

### Core Frameworks and Libraries

- React
- Next.js
- TypeScript
- TanStack Query
- TanStack Router
- Tailwind CSS
- MUI
- Radix UI Primitives
- Radix Colors
- Radix Icons
- React Flow
- Zustand
- Redux Toolkit
- Jotai
- SWR
- DOMPurify
- Storybook

### Design, UI, and Generation References

- `https://github.com/ibelick/ui-skills`
- `https://21st.dev/magic`
- `https://github.com/shadcn-ui/ui`
- `https://github.com/zarazhangrui/frontend-slides`

### Performance and React References

- `https://swr.vercel.app`
- `https://github.com/shuding/better-all`
- `https://github.com/isaacs/node-lru-cache`
- `https://vercel.com/blog/how-we-optimized-package-imports-in-next-js`
- `https://vercel.com/blog/how-we-made-the-vercel-dashboard-twice-as-fast`
- `https://vercel.com/docs/fluid-compute`

### Visual Validation and Testing References

- Chromatic
- Percy
- Applitools
- BackstopJS
- Playwright visual comparisons
- Cypress visual testing
- Jest image snapshot

### Tailwind and Design System References

- `https://tailwindcss.com/docs`
- `https://github.com/tailwindlabs/tailwindcss-container-queries`
- `https://www.radix-ui.com/primitives`
- `https://www.radix-ui.com/colors`
- `https://www.radix-ui.com/icons`

### 3D and Advanced Interaction References

- Spline
- `@splinetool/react-spline`
- Three.js
- React Three Fiber

### Provenance Notes

Source-specific origins present in the existing skill set include:

- `vibeship-spawner-skills (Apache 2.0)`
- `Dimillian/Skills (MIT)`
- community-authored skill files
- local or self-authored skill files already in this repository

This file is the single merged frontend skill. It consolidates the practical guidance from the existing frontend markdown files and nested frontend skill directories into one working playbook.
