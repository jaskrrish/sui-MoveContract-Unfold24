#[allow(duplicate_alias)]
module test_nft::professional_nft {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{String};

    // Struct representing the Professional NFT
    public struct ProfessionalNFT has key, store {
        id: UID,
        title : String,
        description: String,
        stats: String,
        github_url: String,
        twitter_url: String,
        contract_address: address,
        tech_score: u8,
        social_score: u8    
    }

    // Admin capability for managing the NFT collection
    public struct AdminCap has key, store {
        id: UID
    }

    // One-time witness for creating the NFT collection
    public struct PROFESSIONAL_NFT has drop {}

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(PROFESSIONAL_NFT{}, ctx);
    }


    // Initialization function
    fun init(_otw: PROFESSIONAL_NFT, ctx: &mut TxContext) {
        // Create and transfer admin capabilities
        let admin_cap = AdminCap {
            id: object::new(ctx)
        };
        transfer::public_transfer(admin_cap, tx_context::sender(ctx));
    }

    // Mint a new Professional NFT
    public fun mint_professional_nft(
        title: String,
        description: String, 
        stats: String, 
        github_url: String, 
        twitter_url: String,
        contract_address: address,
        tech_score: u8,
        social_score: u8,
        recipient: address,
        ctx: &mut TxContext
    ) {
        // Validate AI score (assuming 0-100 scale)
        assert!(tech_score <= 100, 0);
        assert!(social_score <= 100, 0);

        // Create the NFT
        let nft = ProfessionalNFT {
            id: object::new(ctx),
            title,
            description,
            stats,
            github_url,
            twitter_url,
            contract_address,
            tech_score,
            social_score
        };

        // Transfer the NFT to the recipient
        transfer::transfer(nft, recipient);
    }

    // Update NFT description
    public fun update_title(nft: &mut ProfessionalNFT, title: String) {
        nft.title = title;
    }

    public fun update_description(nft: &mut ProfessionalNFT, new_description: String) {
        nft.description = new_description;
    }

    // Update stats
    public fun update_stats(nft: &mut ProfessionalNFT, new_stats: String) {
        nft.stats = new_stats;
    }

    // Update AI score
    public fun update_tech_score(nft: &mut ProfessionalNFT, new_tech_score: u8) {
        // Validate AI score
        assert!(new_tech_score <= 100, 0);
        nft.tech_score = new_tech_score;
    }

    // Update AI score
    public fun update_social_score(nft: &mut ProfessionalNFT, new_social_score: u8) {
        // Validate AI score
        assert!(new_social_score <= 100, 0);
        nft.social_score = new_social_score;
    }

    public fun get_title(nft: &ProfessionalNFT): String {
        nft.title
    }

    // Accessor functions
    public fun get_description(nft: &ProfessionalNFT): String {
        nft.description
    }

    public fun get_stats(nft: &ProfessionalNFT): String {
        nft.stats
    }

    public fun get_github_url(nft: &ProfessionalNFT): String {
        nft.github_url
    }

    public fun get_twitter_url(nft: &ProfessionalNFT): String {
        nft.twitter_url
    }

    public fun get_contract_address(nft: &ProfessionalNFT): address {
        nft.contract_address
    }

    public fun get_tech_score(nft: &ProfessionalNFT): u8 {
        nft.tech_score
    }

    public fun get_social_score(nft: &ProfessionalNFT): u8 {
        nft.social_score
    }

    // Function to burn (destroy) the NFT
    public fun burn(nft: ProfessionalNFT) {
        let ProfessionalNFT { 
            id,
            title: _,
            description: _, 
            stats: _, 
            github_url: _, 
            twitter_url: _,
            contract_address: _,
            tech_score: _, 
            social_score: _ 
        } = nft;
        object::delete(id);
    }
}