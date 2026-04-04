# ============================================================
# disease_info.py
# Complete treatment + doctor advice database for all 7 classes
# ============================================================

DISEASE_INFO = {

    # ─────────────────────────────────────────────────────────
    "mel": {
        "name":        "Melanoma",
        "risk":        "high",
        "risk_color":  "red",
        "risk_label":  "HIGH RISK — Urgent medical attention needed",

        "what_is_it": (
            "Melanoma is the most dangerous form of skin cancer. "
            "It starts in the melanocytes — the cells that give skin its colour. "
            "It can spread to other organs if not caught early. "
            "Early detection gives a 98% survival rate. Late detection drops to 23%."
        ),

        "symptoms": [
            "Asymmetrical mole — one half does not match the other",
            "Irregular, ragged, or blurred border",
            "Multiple colours in one lesion (brown, black, red, white, blue)",
            "Diameter larger than 6mm (bigger than a pencil eraser)",
            "Evolving — changing in size, shape, or colour over weeks",
            "Itching, bleeding, or crusting of an existing mole",
            "A new growth that looks different from your other moles",
        ],

        "home_care": [
            "Do NOT attempt any home treatment — this is serious",
            "Do not scratch, pick, or irritate the area",
            "Cover loosely with a clean bandage if it is bleeding",
            "Apply SPF 50+ sunscreen to surrounding skin daily",
            "Take clear photos of the lesion every 2–3 days to track changes",
            "Avoid all sun exposure on the affected area",
            "Write down when you first noticed it and any changes since",
        ],

        "treatments": [
            {
                "name":        "Surgical excision",
                "type":        "First-line treatment",
                "description": "The melanoma and surrounding tissue are surgically removed. This is the primary treatment for early-stage melanoma.",
                "done_by":     "Dermatologist or surgeon",
            },
            {
                "name":        "Sentinel lymph node biopsy",
                "type":        "Staging procedure",
                "description": "Checks if the cancer has spread to nearby lymph nodes. Guides further treatment decisions.",
                "done_by":     "Surgical oncologist",
            },
            {
                "name":        "Immunotherapy",
                "type":        "Advanced stage treatment",
                "description": "Drugs like pembrolizumab or nivolumab boost your immune system to fight cancer cells.",
                "done_by":     "Oncologist",
            },
            {
                "name":        "Targeted therapy",
                "type":        "Advanced stage treatment",
                "description": "If BRAF mutation is present, drugs like vemurafenib target the specific mutation.",
                "done_by":     "Oncologist",
            },
            {
                "name":        "Radiation therapy",
                "type":        "Supplementary treatment",
                "description": "Used when surgery is not possible or cancer has spread to brain or bones.",
                "done_by":     "Radiation oncologist",
            },
        ],

        "doctor_advice": {
            "specialist":    "Dermatologist → Surgical Oncologist",
            "urgency":       "Book an appointment within 48–72 hours",
            "urgency_level": "urgent",
            "what_to_say":   "Tell the doctor: 'I have a changing mole that may be melanoma. I need an urgent skin biopsy.'",
            "tests_expect":  [
                "Dermoscopy (magnified skin examination)",
                "Skin punch biopsy (tissue sample sent to lab)",
                "Full body skin check",
                "Lymph node ultrasound if biopsy confirms melanoma",
            ],
            "questions_to_ask": [
                "What stage is this melanoma?",
                "Has it spread to any lymph nodes?",
                "What are my treatment options?",
                "What are the survival statistics for my case?",
                "Do I need a referral to an oncologist?",
            ],
        },

        "emergency_signs": [
            "The lesion is actively bleeding and will not stop",
            "Rapid increase in size over days",
            "Severe pain in the affected area",
            "Swollen lymph nodes in armpit, groin, or neck",
            "Unexplained weight loss alongside the skin changes",
        ],

        "see_doctor":  True,
        "see_emergency": False,
    },

    # ─────────────────────────────────────────────────────────
    "bcc": {
        "name":        "Basal Cell Carcinoma",
        "risk":        "high",
        "risk_color":  "orange",
        "risk_label":  "HIGH RISK — Medical attention needed soon",

        "what_is_it": (
            "Basal Cell Carcinoma (BCC) is the most common skin cancer worldwide. "
            "It grows slowly and rarely spreads to other organs, but it can cause "
            "significant local damage to skin, nerves, and bone if left untreated. "
            "It is highly curable when caught early."
        ),

        "symptoms": [
            "Pearly or waxy bump, often with visible blood vessels",
            "Flat, flesh-coloured or brown scar-like lesion",
            "Pink growth with raised edges and a crusted centre",
            "A sore that heals, then reopens and bleeds again",
            "Shiny, skin-coloured nodule that may look like a mole",
            "Most commonly appears on face, neck, and hands",
        ],

        "home_care": [
            "Apply SPF 50+ broad-spectrum sunscreen every morning",
            "Wear a wide-brimmed hat outdoors",
            "Avoid peak UV hours — 10am to 4pm",
            "Keep the area clean — wash gently with mild soap",
            "Do not scratch or pick at the growth",
            "Wear UV-protective clothing when outdoors",
            "Take monthly self-skin check photos",
        ],

        "treatments": [
            {
                "name":        "Surgical excision",
                "type":        "Standard treatment",
                "description": "The BCC and a margin of normal skin are cut out under local anaesthetic. Cure rate over 95%.",
                "done_by":     "Dermatologist or plastic surgeon",
            },
            {
                "name":        "Mohs surgery",
                "type":        "Best for face / complex areas",
                "description": "Layers of skin are removed one at a time and checked under a microscope until no cancer remains. Highest cure rate (99%).",
                "done_by":     "Mohs surgeon",
            },
            {
                "name":        "Cryotherapy",
                "type":        "For small / superficial BCC",
                "description": "Liquid nitrogen freezes and destroys the cancerous cells. Quick, done in the clinic.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Topical creams",
                "type":        "For superficial BCC only",
                "description": "Imiquimod (Aldara) or 5-fluorouracil cream applied daily for several weeks stimulates immune response.",
                "done_by":     "Self-applied under doctor supervision",
            },
            {
                "name":        "Photodynamic therapy (PDT)",
                "type":        "Alternative for superficial BCC",
                "description": "A light-sensitive cream is applied, then activated by a special light to destroy cancer cells.",
                "done_by":     "Dermatologist",
            },
        ],

        "doctor_advice": {
            "specialist":    "Dermatologist",
            "urgency":       "Book within 2–4 weeks",
            "urgency_level": "soon",
            "what_to_say":   "Tell the doctor: 'I have a slow-growing, pearly bump or recurring sore on my skin that I am concerned may be a basal cell carcinoma.'",
            "tests_expect":  [
                "Visual examination with dermoscope",
                "Skin biopsy (shave or punch) under local anaesthetic",
                "Pathology report (results in 5–10 days)",
            ],
            "questions_to_ask": [
                "How deep has this grown?",
                "Which treatment has the best cure rate for my case?",
                "Will there be scarring after treatment?",
                "Do I need to check my whole body for more?",
                "How often should I come back for skin checks?",
            ],
        },

        "emergency_signs": [
            "Rapid growth suddenly visible over days",
            "Deep ulceration or a wound that will not heal",
            "Numbness or pain in the area — may indicate nerve involvement",
        ],

        "see_doctor":    True,
        "see_emergency": False,
    },

    # ─────────────────────────────────────────────────────────
    "akiec": {
        "name":        "Actinic Keratoses",
        "risk":        "medium",
        "risk_color":  "amber",
        "risk_label":  "MEDIUM RISK — Monitor and see a doctor",

        "what_is_it": (
            "Actinic Keratoses (AK) are rough, scaly patches caused by years of sun "
            "exposure. They are pre-cancerous — meaning they are not yet cancer, but "
            "5–10% of untreated AKs can develop into squamous cell carcinoma over time. "
            "Treatment is simple and very effective when done early."
        ),

        "symptoms": [
            "Rough, dry, scaly patch — feels like sandpaper",
            "Flat to slightly raised patch on sun-exposed skin",
            "Pink, red, or brown discolouration",
            "Hard, wart-like surface in some cases",
            "Itching, burning, or tenderness in the patch",
            "Most common on face, ears, scalp, neck, and hands",
        ],

        "home_care": [
            "Apply SPF 50+ sunscreen every single morning, even indoors",
            "Reapply sunscreen every 2 hours when outdoors",
            "Wear protective clothing — long sleeves, wide-brimmed hat",
            "Avoid sun exposure between 10am and 4pm",
            "Moisturise the area daily — dry skin worsens AK",
            "Do not pick or scratch the patches",
            "Monitor patches monthly — photograph them to track changes",
        ],

        "treatments": [
            {
                "name":        "Cryotherapy",
                "type":        "Most common treatment",
                "description": "Liquid nitrogen is sprayed onto the patch for a few seconds, freezing and destroying the abnormal cells. Quick in-clinic procedure.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Imiquimod cream (Aldara 5%)",
                "type":        "Topical prescription cream",
                "description": "Applied 3 times per week for 4–16 weeks. Activates immune system to destroy abnormal cells. Good for large or multiple patches.",
                "done_by":     "Self-applied under doctor prescription",
            },
            {
                "name":        "5-Fluorouracil cream (Efudex)",
                "type":        "Topical chemotherapy cream",
                "description": "Applied daily for 2–4 weeks. Destroys rapidly dividing abnormal cells. Causes temporary redness and peeling.",
                "done_by":     "Self-applied under doctor prescription",
            },
            {
                "name":        "Photodynamic therapy (PDT)",
                "type":        "For large areas",
                "description": "Light-activated treatment. Excellent for treating large areas of the face or scalp at once.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Chemical peeling",
                "type":        "For multiple, thin AKs",
                "description": "Trichloroacetic acid (TCA) peel removes the surface layer of skin including the AK patches.",
                "done_by":     "Dermatologist",
            },
        ],

        "doctor_advice": {
            "specialist":    "Dermatologist or GP",
            "urgency":       "Book a check-up within 4–6 weeks",
            "urgency_level": "routine",
            "what_to_say":   "Tell the doctor: 'I have rough, scaly patches on sun-exposed skin. I think they may be actinic keratoses and I would like them checked and treated.'",
            "tests_expect":  [
                "Visual and dermoscopic examination",
                "Biopsy only if the patch looks suspicious for full carcinoma",
            ],
            "questions_to_ask": [
                "How many patches do I have?",
                "Which treatment option is best for my skin type?",
                "How likely is this to turn into cancer if untreated?",
                "Should I have a full body skin check?",
                "How often should I come back for follow-up?",
            ],
        },

        "emergency_signs": [
            "A patch becomes a raised, hard, rapidly growing lump",
            "The patch starts bleeding without any scratching",
            "Spreading redness around the area",
        ],

        "see_doctor":    True,
        "see_emergency": False,
    },

    # ─────────────────────────────────────────────────────────
    "bkl": {
        "name":        "Benign Keratosis",
        "risk":        "low",
        "risk_color":  "green",
        "risk_label":  "LOW RISK — Benign, no treatment required",

        "what_is_it": (
            "Benign Keratosis (also called Seborrhoeic Keratosis) is a completely "
            "harmless, non-cancerous skin growth. They are extremely common and "
            "appear more frequently with age. They are not contagious, do not turn "
            "into cancer, and require no treatment unless they cause discomfort or "
            "concern about appearance."
        ),

        "symptoms": [
            "Waxy, scaly, slightly raised growths",
            "Brown, black, tan, or pale colour",
            "Round or oval shape with a flat or slightly raised surface",
            "Characteristic 'stuck-on' appearance — like a sticker on skin",
            "Rough, warty texture in some cases",
            "Usually 1cm to 3cm in size",
            "Often appear in clusters on the chest, back, or face",
        ],

        "home_care": [
            "No treatment is necessary for most cases",
            "Keep the area moisturised to reduce itching",
            "Avoid scratching — this can cause infection",
            "Do not attempt to remove at home (cutting, burning, or chemicals)",
            "Wear loose clothing if the growth is in an area prone to friction",
            "Monitor for any rapid changes in size or appearance",
            "Annual skin checks are still recommended as good practice",
        ],

        "treatments": [
            {
                "name":        "Cryotherapy",
                "type":        "Cosmetic removal",
                "description": "Liquid nitrogen freezes the growth off. Quick and effective. May leave a light mark.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Electrocautery / curettage",
                "type":        "Cosmetic removal",
                "description": "A small electric current burns the growth away, then it is scraped off. Very effective.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Laser removal",
                "type":        "Cosmetic removal",
                "description": "Laser vaporises the growth with minimal scarring. Good for facial lesions.",
                "done_by":     "Dermatologist or cosmetic doctor",
            },
            {
                "name":        "Shave removal",
                "type":        "Cosmetic removal",
                "description": "The growth is shaved off under local anaesthetic. Heals quickly.",
                "done_by":     "Dermatologist",
            },
        ],

        "doctor_advice": {
            "specialist":    "GP or Dermatologist",
            "urgency":       "No urgency — mention at your next routine visit",
            "urgency_level": "routine",
            "what_to_say":   "Tell the doctor: 'I have a rough, stuck-on growth on my skin. I believe it is a seborrhoeic keratosis. I would like it confirmed and possibly removed if it is cosmetically bothering me.'",
            "tests_expect":  [
                "Visual examination only in most cases",
                "Dermoscopy to confirm it is not a melanoma",
                "Biopsy only if appearance is unusual",
            ],
            "questions_to_ask": [
                "Is this definitely benign?",
                "Does it need to be removed?",
                "What is the best cosmetic removal option?",
                "Will it come back after removal?",
                "Should I watch any of my other similar growths?",
            ],
        },

        "emergency_signs": [
            "Rapid change in size over days or weeks",
            "New areas of black colour appearing within the growth",
            "Starts bleeding without any injury",
        ],

        "see_doctor":    False,
        "see_emergency": False,
    },

    # ─────────────────────────────────────────────────────────
    "df": {
        "name":        "Dermatofibroma",
        "risk":        "low",
        "risk_color":  "green",
        "risk_label":  "LOW RISK — Benign fibrous nodule",

        "what_is_it": (
            "A dermatofibroma is a common, harmless fibrous nodule that grows in "
            "the dermis (deep skin layer). They often appear after a minor injury "
            "like an insect bite or ingrown hair. They are completely benign, do not "
            "turn into cancer, and almost never need treatment."
        ),

        "symptoms": [
            "Firm, raised nodule — feels hard like a button under skin",
            "Pink, red, gray, or brown colour",
            "Usually 0.5cm to 1.5cm — small and round",
            "Dimples inward when pinched (the 'dimple sign')",
            "Usually found on legs, but can appear anywhere",
            "May be slightly tender or itchy when touched",
            "Typically stays the same size for years",
        ],

        "home_care": [
            "No treatment is necessary",
            "Avoid trauma to the nodule — bumping it can cause irritation",
            "Apply moisturiser if the skin over it becomes dry or itchy",
            "Do not attempt to squeeze or pop it",
            "Loose clothing reduces friction if it is in a sensitive location",
            "Monitor for any rapid or unusual change in size",
        ],

        "treatments": [
            {
                "name":        "Surgical excision",
                "type":        "Cosmetic removal",
                "description": "Complete surgical removal under local anaesthetic. Will leave a small scar. Only recommended if it is painful or cosmetically bothersome.",
                "done_by":     "Dermatologist or surgeon",
            },
            {
                "name":        "Cryotherapy",
                "type":        "Flattening (not full removal)",
                "description": "Liquid nitrogen can flatten the nodule but rarely removes it completely. May need repeat sessions.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Steroid injections",
                "type":        "To reduce size/itching",
                "description": "Corticosteroid injected directly into the nodule can reduce its size and relieve itching.",
                "done_by":     "Dermatologist",
            },
        ],

        "doctor_advice": {
            "specialist":    "GP or Dermatologist",
            "urgency":       "No urgency — mention at your next routine check",
            "urgency_level": "routine",
            "what_to_say":   "Tell the doctor: 'I have a firm, round nodule on my skin that dimples inward when I pinch it. I think it may be a dermatofibroma and want it confirmed.'",
            "tests_expect":  [
                "Clinical examination — the dimple sign is usually diagnostic",
                "Dermoscopy to confirm appearance",
                "Biopsy only if the diagnosis is uncertain",
            ],
            "questions_to_ask": [
                "Is this definitely a dermatofibroma?",
                "Does it need any treatment?",
                "What removal options do I have?",
                "Will it grow back if removed?",
            ],
        },

        "emergency_signs": [
            "Rapid growth suddenly visible over days",
            "New ulceration or bleeding on the surface",
            "Multiple new similar nodules appearing at the same time",
        ],

        "see_doctor":    False,
        "see_emergency": False,
    },

    # ─────────────────────────────────────────────────────────
    "nv": {
        "name":        "Melanocytic Nevi",
        "risk":        "low",
        "risk_color":  "green",
        "risk_label":  "LOW RISK — Common benign mole",

        "what_is_it": (
            "Melanocytic Nevi are ordinary moles — clusters of pigmented melanocyte "
            "cells in the skin. Most adults have 10–40 moles. They are almost always "
            "completely harmless. The important thing is to monitor them with the ABCDE "
            "rule and report any changes to a doctor, as a small number can develop "
            "into melanoma over time."
        ),

        "symptoms": [
            "Small, round, symmetrical growth",
            "Consistent brown or tan colour — uniform throughout",
            "Smooth, even border — clearly defined edge",
            "Usually less than 6mm in diameter",
            "Flat or slightly raised surface",
            "Stable — same appearance for months and years",
            "Can appear anywhere on the body",
        ],

        "home_care": [
            "Apply SPF 50+ sunscreen every morning — UV causes moles to change",
            "Perform a monthly self skin check using the ABCDE rule",
            "Photograph all moles every 3 months to compare over time",
            "Use the ABCDE rule: Asymmetry, Border, Colour, Diameter, Evolving",
            "Avoid tanning beds — they significantly increase melanoma risk",
            "Wear protective clothing and sunglasses outdoors",
            "Check moles in hidden areas — scalp, between toes, under nails",
        ],

        "treatments": [
            {
                "name":        "No treatment needed",
                "type":        "Standard approach",
                "description": "Most moles require no treatment. Regular monitoring is sufficient.",
                "done_by":     "Self-monitoring",
            },
            {
                "name":        "Surgical excision",
                "type":        "If cosmetically bothersome or suspicious",
                "description": "The mole is cut out with a small margin. Tissue is sent to pathology to confirm it is benign.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Shave removal",
                "type":        "For raised, non-suspicious moles",
                "description": "The raised portion is shaved flush with the skin surface. Quick and leaves minimal scarring.",
                "done_by":     "Dermatologist",
            },
        ],

        "doctor_advice": {
            "specialist":    "Dermatologist or GP",
            "urgency":       "Annual routine skin check recommended",
            "urgency_level": "routine",
            "what_to_say":   "Tell the doctor: 'I would like an annual mole check. I also have a mole I have been monitoring and would like your opinion on it.'",
            "tests_expect":  [
                "Full body dermoscopy (mole mapping)",
                "Biopsy only if a specific mole appears concerning",
            ],
            "questions_to_ask": [
                "Do any of my moles look concerning to you?",
                "Should I get full body mole mapping?",
                "Which moles should I watch most carefully?",
                "At what changes should I come back immediately?",
            ],
        },

        "emergency_signs": [
            "Any mole that bleeds without injury",
            "A mole that changes shape or colour within a few weeks",
            "A mole that becomes suddenly painful or itchy",
            "A new, dark mole that grows very quickly",
        ],

        "see_doctor":    False,
        "see_emergency": False,
    },

    # ─────────────────────────────────────────────────────────
    "vasc": {
        "name":        "Vascular Lesions",
        "risk":        "low",
        "risk_color":  "green",
        "risk_label":  "LOW RISK — Benign blood vessel condition",

        "what_is_it": (
            "Vascular lesions are benign growths related to blood vessels in the skin. "
            "This group includes cherry angiomas (bright red spots), pyogenic granulomas "
            "(red, bleed-prone bumps), and spider angiomas (spider-shaped red marks). "
            "They are not dangerous, do not become cancerous, but can bleed easily if "
            "scratched and are often removed for cosmetic reasons."
        ),

        "symptoms": [
            "Bright red, purple, or blue colour",
            "Smooth, soft surface",
            "May bleed easily and heavily if scratched or cut",
            "Cherry angiomas: small, round, bright red dots",
            "Pyogenic granulomas: larger, raised, moist-looking red bumps",
            "Spider angiomas: central red spot with radiating red lines",
            "Can appear anywhere on the body",
        ],

        "home_care": [
            "Avoid trauma, scratching, or rubbing the lesion",
            "Keep the area clean and dry",
            "If it bleeds, apply firm pressure for 10–15 minutes",
            "Cover with a clean, non-stick bandage after any bleeding",
            "Do not attempt to remove at home",
            "Wear protective clothing if in an area prone to catching on fabric",
        ],

        "treatments": [
            {
                "name":        "Laser therapy (pulsed dye laser)",
                "type":        "Best cosmetic option",
                "description": "A laser targets haemoglobin in the blood vessels, destroying them without damaging surrounding skin. Minimal scarring.",
                "done_by":     "Dermatologist or cosmetic clinic",
            },
            {
                "name":        "Electrocautery",
                "type":        "Common and effective",
                "description": "A fine electric needle burns the lesion away. Quick procedure done under local anaesthetic.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Cryotherapy",
                "type":        "For small lesions",
                "description": "Liquid nitrogen freezes and destroys the blood vessel growth.",
                "done_by":     "Dermatologist",
            },
            {
                "name":        "Surgical removal",
                "type":        "For large pyogenic granulomas",
                "description": "Larger lesions are surgically excised to prevent regrowth. Tissue sent to confirm benign diagnosis.",
                "done_by":     "Dermatologist or surgeon",
            },
        ],

        "doctor_advice": {
            "specialist":    "GP or Dermatologist",
            "urgency":       "No urgency unless it is bleeding frequently",
            "urgency_level": "routine",
            "what_to_say":   "Tell the doctor: 'I have a red vascular lesion on my skin. I would like it checked and am interested in cosmetic removal options.'",
            "tests_expect":  [
                "Visual and dermoscopic examination",
                "Biopsy only for larger or unusual lesions to confirm benign",
            ],
            "questions_to_ask": [
                "What type of vascular lesion is this exactly?",
                "Does it need treatment or can I leave it?",
                "What is the best cosmetic removal method?",
                "Will it bleed again after removal?",
                "Is this related to any internal condition?",
            ],
        },

        "emergency_signs": [
            "Lesion bleeds and will not stop after 15 minutes of firm pressure",
            "Rapidly enlarging over days (especially pyogenic granuloma)",
            "Multiple new lesions appearing suddenly all over the body",
        ],

        "see_doctor":    False,
        "see_emergency": False,
    },
}