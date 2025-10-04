# ADR-3: How to Display the Detailed Explanation of the Calculation

**Status:** Accepted

## Context

I would like to give the users the opportunity to understand how the calculation is done. For one because they might
simply be interested, but also in order to build trust. I already wrote a long company internal article about it, so I
could reuse parts of it. However, a simple pdf export does not work, as the latex formulas are not displayed correctly
but only in their original form. So independent of how I display it, I want to reuse that with minor editing or
rewording. This decision is about how to display it to the user.

## Considered Options

1. Write a pdf document with latex and simply hand it over to the user. I would expect the operating system to open it
   in the respective program and therefore outside the application.
2. Display it in the app itself. This seems more difficult to me, as it requires the correct display of latex formulas
   and pictures. Also, all kinds of resizing would have to be accounted for.

## Decision

For now, I will go with option 1, because I think it is a lot easier to implement in a failsafe way. The PDF document
can
be generated at build time and is safe to be displayed correctly on all kinds of screens. It may disrupt the user
experience a bit by forcing the user to look at it in another application, but that seems acceptable to me. I will
include the entire sources of the document in this repository, such that it can be regenerated and modified at any time.
I'm not sure yet if I want to set up an automated build process for it. Maybe for now this is a bit of an overkill.

Update on 04.10.2025:
It turns out that opening the pdf with other programs is not as straightforward as I thought. So now I will first try to
display it within the app itself. This will make me more independent of the operating system that the application is
running on.