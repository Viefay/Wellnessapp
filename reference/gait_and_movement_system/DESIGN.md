---
name: Gait and Movement System
colors:
  surface: '#f4fbf8'
  surface-dim: '#d5dbd9'
  surface-bright: '#f4fbf8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff5f3'
  surface-container: '#e9efed'
  surface-container-high: '#e3eae7'
  surface-container-highest: '#dde4e2'
  on-surface: '#161d1c'
  on-surface-variant: '#3c4947'
  inverse-surface: '#2b3230'
  inverse-on-surface: '#ecf2f0'
  outline: '#6c7a77'
  outline-variant: '#bbcac6'
  surface-tint: '#006a62'
  primary: '#006a62'
  on-primary: '#ffffff'
  primary-container: '#2ec4b6'
  on-primary-container: '#004c46'
  inverse-primary: '#4fdbcc'
  secondary: '#485f84'
  on-secondary: '#ffffff'
  secondary-container: '#bbd3fd'
  on-secondary-container: '#445a7f'
  tertiary: '#9a4520'
  on-tertiary: '#ffffff'
  tertiary-container: '#ff9468'
  on-tertiary-container: '#762b06'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#70f8e8'
  primary-fixed-dim: '#4fdbcc'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#005049'
  secondary-fixed: '#d5e3ff'
  secondary-fixed-dim: '#b0c7f1'
  on-secondary-fixed: '#001b3c'
  on-secondary-fixed-variant: '#30476a'
  tertiary-fixed: '#ffdbce'
  tertiary-fixed-dim: '#ffb599'
  on-tertiary-fixed: '#370e00'
  on-tertiary-fixed-variant: '#7b2f0a'
  background: '#f4fbf8'
  on-background: '#161d1c'
  surface-variant: '#dde4e2'
typography:
  display-lg:
    fontFamily: Nunito Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Nunito Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-sm:
    fontFamily: Nunito Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
  body-lg:
    fontFamily: Nunito Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Nunito Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  data-viz:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 18px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 20px
  gutter-mobile: 16px
---

## Brand & Style

This design system is built to bridge the gap between clinical precision and holistic wellness. The brand personality is **Professional, Supportive, and Tech-Forward**, ensuring users feel they are receiving expert medical-grade analysis within a warm, non-intimidating environment.

The visual style follows a **Modern Wellness** aesthetic: 
- **Minimalism** is used to reduce cognitive load during complex movement assessments.
- **Softness** is achieved through generous radii and a gentle color palette, removing the "coldness" often associated with medical software.
- **Clarity** is prioritized through high-contrast typography and intentional whitespace, making data-heavy gait reports easy to digest at a glance.

The target audience ranges from recovering patients to athletes, necessitating a UI that feels both rehabilitative and performance-oriented.

## Colors

The palette is anchored by **Soft Teal**, chosen for its associations with healing and modern technology. **Deep Navy** provides the necessary weight and "medical authority" for text and primary actions, ensuring the interface feels grounded.

- **Surface Strategy:** Use the Soft Off-White for the global background to reduce screen glare. Reserve pure White for interactive cards and containers to create a clear "layering" effect.
- **Feedback Loop:** Success, Warning, and Danger colors are calibrated for high legibility against white backgrounds, specifically for gait score indicators (e.g., asymmetry alerts).
- **Accents:** Use the Mint accent for secondary backgrounds, chip fills, or progress bar tracks to maintain a cohesive monochromatic feel with the primary teal.

## Typography

This design system utilizes **Nunito Sans** for its rounded, approachable terminals, which reinforce the "friendly" brand pillar. **Inter** is introduced for labels and data visualization due to its superior legibility at small scales and more technical, "medical" structure.

- **Headlines:** Use Bold and ExtraBold weights to create clear entry points on the page. 
- **Data Display:** For gait metrics (e.g., "Step Length: 64cm"), use Inter Bold to distinguish quantitative data from qualitative descriptions.
- **Accessibility:** Maintain a minimum body size of 16px to ensure readability for users who may have limited mobility or are viewing the device from a distance (e.g., during a floor-based movement test).

## Layout & Spacing

The layout philosophy is based on a **4-column fluid grid** for mobile (iPhone 14), emphasizing vertical rhythm and generous breathing room.

- **Safe Zones:** Adhere to a 20px horizontal margin to prevent content from crowding the screen edges.
- **Vertical Spacing:** Use the `xl` (32px) spacing unit to separate major sections (e.g., separating the "Gait Score" card from the "Exercise Recommendations" list).
- **Alignment:** Center-align primary assessment triggers (like "Start Analysis") to ensure they are easily reachable with the thumb. 
- **Whitespace:** Use whitespace as a separator rather than lines whenever possible to maintain a clean, minimalist feel.

## Elevation & Depth

Hierarchy is established through **Ambient Shadows** and tonal layering. 

- **Level 0 (Background):** Soft Off-White (#F7F9FA).
- **Level 1 (Cards):** Pure White (#FFFFFF) with a very soft, diffused shadow. Shadow properties: `x: 0, y: 4, blur: 20, spread: 0, color: rgba(29, 53, 87, 0.06)`. Note the subtle Navy tint in the shadow to keep it "cool" and professional.
- **Level 2 (Active/Floating):** Used for primary buttons or active assessment overlays. Shadow: `x: 0, y: 8, blur: 24, color: rgba(46, 196, 182, 0.15)`. This uses a Primary Teal tint to emphasize interactivity.
- **Glassmorphism:** Use a light backdrop blur (10px) on the bottom navigation bar and top headers to maintain a sense of depth while scrolling.

## Shapes

The shape language is defined by **Extreme Roundness**, conveying a sense of safety and friendliness.

- **Primary Containers:** All cards and main feature blocks use a 24px (`rounded-xl` in this system) corner radius.
- **Buttons:** Action buttons should be pill-shaped (fully rounded) to maximize the "friendly" aesthetic and differentiate them from informational cards.
- **Selection Indicators:** Use small, 8px rounded corners for secondary elements like chips or segmented controls to maintain harmony without over-rounding small components.

## Components

### Buttons
- **Primary:** Deep Navy background with White text. Pill-shaped. High emphasis.
- **Secondary:** Soft Teal background with White text or Mint background with Soft Teal text for lower-priority actions.
- **Ghost:** Soft Teal text with no background, used for "Cancel" or "Back" actions.

### Cards & Assessment Blocks
- **Assessment Card:** White background, 24px radius, soft navy shadow. Should include a "Status" chip (e.g., "Complete" in Green or "Pending" in Orange) in the top right.
- **Metric Card:** Used for Gait Analysis results. Features a large Inter-bold number with a sub-label in Muted text.

### Inputs & Selection
- **Text Fields:** Light Border (#E9ECEF) with a 12px radius. On focus, the border transitions to Soft Teal.
- **Segmented Control:** A pill-shaped toggle used for switching between "Left Foot" and "Right Foot" data views.

### Icons & Illustrations
- **Icons:** 2px stroke weight, line-style icons. Avoid solid fills unless the icon is in an "active" state. Use Soft Teal or Deep Navy for icon colors.
- **Illustrations:** Minimalist, geometric human figures. Use Teal and Mint for the body forms with Navy for "joints" or "points of interest" in movement assessments.

### Progress & Feedback
- **Gait Score Ring:** A circular progress indicator using Soft Teal for the score and Mint for the remaining track.
- **Checkboxes:** Rounded squares (4px radius) rather than sharp corners, using Teal for the checked state.