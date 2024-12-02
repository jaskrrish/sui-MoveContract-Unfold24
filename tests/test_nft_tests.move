#[test_only]
module test_nft::professional_nft_tests {
    // Importing necessary testing and contract modules
    use sui::test_scenario;
    use sui::tx_context;
    use std::string::{utf8, String};

    use test_nft::professional_nft::{Self, ProfessionalNFT};

    // Test addresses
    const CREATOR: address = @0xA1;
    const USER: address = @0xB2;

    // Helper function to create initial setup
    fun create_nft(): vector<String> {
        let professional_links = vector[
            utf8(b"https://linkedin.com/in/example"),
            utf8(b"https://github.com/example")
        ];
        professional_links
    }

    #[test]
    fun test_mint_professional_nft() {
        let scenario_val = test_scenario::begin(CREATOR);
        let scenario = &mut scenario_val;
        
        // Initialize the module
        {
            let ctx = test_scenario::ctx(scenario);
            test_nft::professional_nft::init(test_nft::professional_nft::PROFESSIONAL_NFT {}, ctx);
        }

        // Mint NFT
        test_scenario::next_tx(scenario, CREATOR);
        {
            let ctx = test_scenario::ctx(scenario);
            let professional_links = create_nft();
            
            test_nft::professional_nft::mint_professional_nft(
                utf8(b"Blockchain Developer"),
                utf8(b"https://example.com/profile.jpg"),
                professional_links,
                85,
                USER,
                ctx
            );
        }

        // Verify NFT attributes
        test_scenario::next_tx(scenario, USER);
        {
            let nft = test_scenario::take_from_sender<ProfessionalNFT>(scenario);
            
            // Check initial values
            assert!(test_nft::professional_nft::get_description(&nft) == utf8(b"Blockchain Developer"), 0);
            assert!(test_nft::professional_nft::get_image_url(&nft) == utf8(b"https://example.com/profile.jpg"), 1);
            assert!(test_nft::professional_nft::get_ai_score(&nft) == 85, 2);
            
            test_scenario::return_to_sender(scenario, nft);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_update_nft_attributes() {
        let scenario_val = test_scenario::begin(CREATOR);
        let scenario = &mut scenario_val;
        
        // Initialize and mint NFT
        {
            let ctx = test_scenario::ctx(scenario);
            test_nft::professional_nft::init(test_nft::professional_nft::PROFESSIONAL_NFT {}, ctx);
        }

        test_scenario::next_tx(scenario, CREATOR);
        {
            let ctx = test_scenario::ctx(scenario);
            let professional_links = create_nft();
            
            test_nft::professional_nft::mint_professional_nft(
                utf8(b"Initial Description"),
                utf8(b"https://initial.com/image.jpg"),
                professional_links,
                50,
                USER,
                ctx
            );
        }

        // Update attributes
        test_scenario::next_tx(scenario, USER);
        {
            let nft = test_scenario::take_from_sender<ProfessionalNFT>(scenario);
            
            // Update description
            test_nft::professional_nft::update_description(&mut nft, utf8(b"Updated Description"));
            
            // Update image URL
            test_nft::professional_nft::update_image_url(&mut nft, utf8(b"https://updated.com/image.jpg"));
            
            // Add professional link
            test_nft::professional_nft::add_professional_link(&mut nft, utf8(b"https://twitter.com/example"));
            
            // Update AI score
            test_nft::professional_nft::update_ai_score(&mut nft, 75);
            
            test_scenario::return_to_sender(scenario, nft);
        };

        // Verify updates
        test_scenario::next_tx(scenario, USER);
        {
            let nft = test_scenario::take_from_sender<ProfessionalNFT>(scenario);
            
            assert!(test_nft::professional_nft::get_description(&nft) == utf8(b"Updated Description"), 0);
            assert!(test_nft::professional_nft::get_image_url(&nft) == utf8(b"https://updated.com/image.jpg"), 1);
            assert!(test_nft::professional_nft::get_ai_score(&nft) == 75, 2);
            
            // Check if professional link was added
            let links = test_nft::professional_nft::get_professional_links(&nft);
            assert!(links.length() == 3, 3);
            
            test_scenario::return_to_sender(scenario, nft);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = 0)]
    fun test_update_ai_score_invalid() {
        let scenario_val = test_scenario::begin(CREATOR);
        let scenario = &mut scenario_val;
        
        // Initialize and mint NFT
        {
            let ctx = test_scenario::ctx(scenario);
            test_nft::professional_nft::init(test_nft::professional_nft::PROFESSIONAL_NFT {}, ctx);
        }

        test_scenario::next_tx(scenario, CREATOR);
        {
            let ctx = test_scenario::ctx(scenario);
            let professional_links = create_nft();
            
            test_nft::professional_nft::mint_professional_nft(
                utf8(b"Test NFT"),
                utf8(b"https://example.com/image.jpg"),
                professional_links,
                50,
                USER,
                ctx
            );
        }

        // Attempt to update AI score with invalid value
        test_scenario::next_tx(scenario, USER);
        {
            let nft = test_scenario::take_from_sender<ProfessionalNFT>(scenario);
            
            // This should fail due to score > 100
            test_nft::professional_nft::update_ai_score(&mut nft, 101);
            
            test_scenario::return_to_sender(scenario, nft);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_burn_nft() {
        let scenario_val = test_scenario::begin(CREATOR);
        let scenario = &mut scenario_val;
        
        // Initialize and mint NFT
        {
            let ctx = test_scenario::ctx(scenario);
            test_nft::professional_nft::init(test_nft::professional_nft::PROFESSIONAL_NFT {}, ctx);
        }

        test_scenario::next_tx(scenario, CREATOR);
        {
            let ctx = test_scenario::ctx(scenario);
            let professional_links = create_nft();
            
            test_nft::professional_nft::mint_professional_nft(
                utf8(b"Burn Test NFT"),
                utf8(b"https://example.com/burn.jpg"),
                professional_links,
                60,
                USER,
                ctx
            );
        }

        // Burn the NFT
        test_scenario::next_tx(scenario, USER);
        {
            let nft = test_scenario::take_from_sender<ProfessionalNFT>(scenario);
            test_nft::professional_nft::burn(nft);
        };

        test_scenario::end(scenario_val);
    }
}